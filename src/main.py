import argparse
import csv
import json
import re
from pathlib import Path
from random import choice
from dataclasses import dataclass, field
from typing import Any
from enum import Enum

from llm import ask_llm
from prompt import build_sql_prompt
from validator import is_safe_sql, normalize_sql
from db import run_query, get_semantic_schema
from explain import build_explanation_prompt
import llm_exceptions as le


class Status(Enum):
    OK = "ok"
    DB_ERROR = "db_error"
    QUESTION_ERROR = "question_error"
    LLM_ERROR = "llm_error"
    CANCELLED = "cancelled"
    UNSAFE_SQL = "unsafe_sql"
    EXPLANATION_ERROR = "explanation_error"

@dataclass
class PipelineResult:
    question: str
    status: Status = Status.OK
    sql: str = ""
    is_safe: bool = False
    message: str = ""
    results: list[Any] = field(default_factory=list)
    explanation: str = ""

    def print_pipeline_result(self) -> None:
        print(
            f"question: {self.question}\n\n"
            f"sql: {self.sql}\n\n"
            f"is_safe: {self.is_safe}\n\n"
            f"message: {self.message}\n\n"
            f"results: {self.results}\n\n"
            f"explanation: \n{self.explanation}\n\n"
            f"status: {self.status.value}\n\n"
        )


CONFIG_PATH = Path(__file__).parent / "config.json"


def load_config() -> dict:
    """Load application config from disk."""
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-t", "--test_mode",
        action="store_true",
        help="Run the script in test mode"
    )
    parser.add_argument(
        "-y", "--question_type",
        type=str,
        choices=["valid", "invalid"],
        help="Select a sample question type"
    )
    parser.add_argument(
        "-q", "--question",
        type=str,
        help="Manually supply an LLM question"
    )
    parser.add_argument(
        "-f", "--file",
        type=str,
        help="Path to a text file containing one test question per line"
    )
    parser.add_argument(
        "-o", "--output",
        type=str,
        default="test_results",
        help="Output directory for test results (default: test_results)"
    )
    return parser.parse_args()


def merge_config(args: argparse.Namespace, config: dict) -> dict:
    merged = config.copy()
    for key, val in vars(args).items():
        if val is not None:
            merged[key] = val
    return merged


def resolve_user_question(config: dict) -> str:
    """Resolve the final user question from CLI input or sample config."""
    if config.get("question"):
        return config["question"]

    question_type = config.get("question_type") or config.get("default_question_mode", "valid")
    sample_questions = config.get("sample_questions", {})

    if question_type not in sample_questions:
        print(f"Error: unknown question type: {question_type}")
        return ""

    return choice(sample_questions[question_type])


def load_questions_from_file(filepath: str) -> list[str]:
    """
    Read test questions from a text file.
    One question per line. Blank lines and lines starting with # are skipped.
    """
    questions = []
    path = Path(filepath)

    if not path.exists():
        print(f"Error: file not found: {filepath}")
        return []

    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                questions.append(line)

    return questions


def slugify(text: str, max_len: int = 50) -> str:
    """
    Convert a question string into a safe directory name fragment.
    Lowercases, replaces spaces and special chars with underscores,
    collapses runs of underscores, and truncates.
    """
    slug = text.lower()
    slug = re.sub(r"[^a-z0-9]+", "_", slug)
    slug = re.sub(r"_+", "_", slug).strip("_")
    return slug[:max_len]


def write_test_result(
    result: PipelineResult,
    test_num: int,
    output_dir: Path
) -> None:
    """
    Write one test result into its own subdirectory:
      output_dir/test_NNN_<slug>/summary.log
      output_dir/test_NNN_<slug>/data.csv  (only if rows exist)
    """
    slug = slugify(result.question)
    test_dir = output_dir / f"test_{test_num:03d}_{slug}"
    test_dir.mkdir(parents=True, exist_ok=True)

    # --- summary.log ---
    log_path = test_dir / "summary.log"
    with open(log_path, "w", encoding="utf-8") as f:
        f.write(f"question   : {result.question}\n")
        f.write(f"status     : {result.status.value}\n")
        f.write(f"is_safe    : {result.is_safe}\n")
        f.write(f"row_count  : {len(result.results)}\n")

        if result.message:
            f.write(f"message    : {result.message}\n")

        f.write("\n--- SQL ---\n")
        f.write(result.sql if result.sql else "(none)\n")

        if result.explanation:
            f.write("\n--- explanation ---\n")
            f.write(result.explanation)
            f.write("\n")

    # --- data.csv (only if rows returned) ---
    if result.results:
        data_path = test_dir / "data.csv"
        fieldnames = list(result.results[0].keys())
        with open(data_path, "w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(result.results)


def main() -> None:
    try:
        args = parse_args()
        config = load_config()
        final_config = merge_config(args, config)

        if final_config.get("test_mode"):
            print("(Running in TEST mode)")

        # --- Batch file mode ---
        if args.file:
            questions = load_questions_from_file(args.file)
            if not questions:
                print("No questions found in file. Exiting.")
                return

            output_dir = Path(args.output)
            output_dir.mkdir(parents=True, exist_ok=True)

            print(f"Loaded {len(questions)} questions from {args.file}")
            print(f"Writing results to: {output_dir}/\n")

            # Load semantic schema once for the whole batch
            semantic_schema = get_semantic_schema()

            for i, question in enumerate(questions, 1):
                print(f"[{i:03d}/{len(questions)}] {question}")
                result = run_pipeline(question, semantic_schema)
                write_test_result(result, i, output_dir)
                status_label = result.status.value
                row_info = f"{len(result.results)} rows" if result.status == Status.OK else result.message[:60]
                print(f"         -> {status_label} | {row_info}")

            print(f"\nDone. {len(questions)} tests written to {output_dir}/")
            return

        # --- Single question mode ---
        user_question = resolve_user_question(final_config)
        if not user_question:
            result = PipelineResult(
                question="",
                status=Status.QUESTION_ERROR,
                message="No question could be resolved"
            )
            result.print_pipeline_result()
            return

        semantic_schema = get_semantic_schema()
        pipeline_result = run_pipeline(user_question, semantic_schema)
        pipeline_result.print_pipeline_result()

    except Exception as exc:
        print(f"\nX Application Error: {exc}")


def run_pipeline(user_question: str, semantic_schema: dict = None) -> PipelineResult:
    """Orchestrate the business flow."""
    result = PipelineResult(question=user_question)

    if semantic_schema is None:
        semantic_schema = get_semantic_schema()

    result = generate_sql_from_question(result, semantic_schema)
    if result.status != Status.OK:
        return result

    result.is_safe, result.message = validate_sql(result.sql)
    if not result.is_safe:
        result.status = Status.UNSAFE_SQL
        return result

    result = execute_query(result)
    if result.status != Status.OK:
        return result

    result = generate_explanation(result)
    if result.status != Status.OK:
        return result

    return result


def generate_sql_from_question(
    result: PipelineResult,
    semantic_schema: dict
) -> PipelineResult:
    """Populate result.sql from user question."""
    prompt = build_sql_prompt(result.question, semantic_schema)

    try:
        sql = ask_llm(prompt)
        if not sql:
            result.status = Status.LLM_ERROR
            result.message = "LLM returned a NULL sql statement"
            return result
    except le.LLMEmptyOutput:
        result.status = Status.LLM_ERROR
        result.message = "LLM returned a NULL sql statement"
        return result
    except Exception as exc:
        result.status = Status.LLM_ERROR
        result.message = f"LLM call failed: {exc}"
        return result

    result.sql = normalize_sql(sql)

    if result.sql is None or result.sql == "":
        result.status = Status.CANCELLED
        result.message = "Normalized SQL was empty."
        return result

    if result.sql == "CANNOT_ANSWER":
        result.status = Status.CANCELLED
        result.message = "LLM indicated it could not answer."
        return result

    return result


def validate_sql(sql: str) -> tuple[bool, str]:
    """Return whether the SQL is safe, plus the validation reason."""
    if sql is None or sql == "" or sql == "CANNOT_ANSWER":
        return False, "Query cancelled or could not be answered."
    return is_safe_sql(sql)


def execute_query(result: PipelineResult) -> PipelineResult:
    """Execute validated SQL and store results."""
    try:
        result.results = run_query(result.sql)
    except Exception as exc:
        result.status = Status.DB_ERROR
        result.message = f"Database execution failed: {exc}"
    return result


def generate_explanation(result: PipelineResult) -> PipelineResult:
    """Generate a plain-English explanation for the query results."""
    try:
        explanation_prompt = build_explanation_prompt(
            result.question,
            result.sql,
            result.results
        )
        result.explanation = ask_llm(explanation_prompt)
    except Exception as exc:
        result.status = Status.EXPLANATION_ERROR
        result.message = f"Explanation generation failed: {exc}"
    return result


if __name__ == "__main__":
    main()
