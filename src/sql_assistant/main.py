import argparse
import csv
import json
import logging
import re
from datetime import datetime, timezone
from pathlib import Path

from .pipeline import run, PipelineResult, Status

_PROJECT_ROOT = Path(__file__).parent.parent.parent  # src/sql_assistant/ → src/ → project root

_LOG_RECORD_ATTRS = frozenset({
    'args', 'created', 'exc_info', 'exc_text', 'filename', 'funcName',
    'levelname', 'levelno', 'lineno', 'message', 'module', 'msecs',
    'msg', 'name', 'pathname', 'process', 'processName', 'relativeCreated',
    'stack_info', 'thread', 'threadName', 'taskName', 'event',
})


class _JsonFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        record.message = record.getMessage()
        dt = datetime.fromtimestamp(record.created, tz=timezone.utc)
        ts = dt.strftime('%Y-%m-%dT%H:%M:%S.') + f"{int(record.msecs):03d}Z"
        obj = {
            "timestamp": ts,
            "level": record.levelname,
            "module": record.module,
            "event": record.message,
        }
        for key, val in record.__dict__.items():
            if key not in _LOG_RECORD_ATTRS:
                obj[key] = val
        return json.dumps(obj)


class _HumanFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        record.message = record.getMessage()
        extras = {k: v for k, v in record.__dict__.items() if k not in _LOG_RECORD_ATTRS}
        base = f"[{record.levelname}] {record.module}: {record.message}"
        if extras:
            extra_str = " ".join(f"{k}={v}" for k, v in extras.items())
            return f"{base} | {extra_str}"
        return base


def configure_logging() -> None:
    from config.settings import settings

    root = logging.getLogger()
    if root.handlers:
        return

    level = getattr(logging, settings.log_level.upper(), logging.INFO)
    root.setLevel(level)

    stdout_handler = logging.StreamHandler()
    stdout_handler.setFormatter(_HumanFormatter())
    root.addHandler(stdout_handler)

    log_path = _PROJECT_ROOT / settings.log_file
    log_path.parent.mkdir(parents=True, exist_ok=True)
    file_handler = logging.FileHandler(log_path, encoding="utf-8")
    file_handler.setFormatter(_JsonFormatter())
    root.addHandler(file_handler)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="AI SQL Assistant")
    parser.add_argument(
        "-q", "--question",
        type=str,
        help="Natural language question to answer with SQL"
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
        help="Output directory for batch test results (default: test_results)"
    )
    return parser.parse_args()


def load_questions_from_file(filepath: str) -> list[str]:
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
    slug = text.lower()
    slug = re.sub(r"[^a-z0-9]+", "_", slug)
    slug = re.sub(r"_+", "_", slug).strip("_")
    return slug[:max_len]


def write_test_result(result: PipelineResult, test_num: int, output_dir: Path) -> None:
    slug = slugify(result.question)
    test_dir = output_dir / f"test_{test_num:03d}_{slug}"
    test_dir.mkdir(parents=True, exist_ok=True)

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

    if result.results:
        data_path = test_dir / "data.csv"
        fieldnames = list(result.results[0].keys())
        with open(data_path, "w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(result.results)


def main() -> None:
    configure_logging()
    try:
        args = parse_args()

        if args.file:
            questions = load_questions_from_file(args.file)
            if not questions:
                print("No questions found in file. Exiting.")
                return

            output_dir = Path(args.output)
            output_dir.mkdir(parents=True, exist_ok=True)

            print(f"Loaded {len(questions)} questions from {args.file}")
            print(f"Writing results to: {output_dir}/\n")

            for i, question in enumerate(questions, 1):
                print(f"[{i:03d}/{len(questions)}] {question}")
                result = run(question)
                write_test_result(result, i, output_dir)
                status_label = result.status.value
                row_info = (
                    f"{len(result.results)} rows"
                    if result.status == Status.OK
                    else result.message[:60]
                )
                print(f"         -> {status_label} | {row_info}")

            print(f"\nDone. {len(questions)} tests written to {output_dir}/")
            return

        if not args.question:
            print("Error: provide --question or --file.")
            return

        result = run(args.question)
        result.print_pipeline_result()

    except Exception as exc:
        print(f"\nX Application Error: {exc}")


if __name__ == "__main__":
    main()
