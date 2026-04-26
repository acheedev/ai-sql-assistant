import logging
import time
from dataclasses import dataclass, field
from enum import Enum
from typing import Any

from .llm import generate_sql
from .prompt import build_sql_prompt
from .validator import is_safe_sql, normalize_sql
from .db import run_query, get_semantic_schema
from .explain import generate_explanation
from . import exceptions as le

logger = logging.getLogger(__name__)


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


def run(question: str) -> PipelineResult:
    start = time.monotonic()
    logger.info("pipeline_start", extra={"event": "pipeline_start", "question": question})

    result = _run_pipeline(question)

    total_ms = int((time.monotonic() - start) * 1000)
    if result.status == Status.OK:
        logger.info("pipeline_complete", extra={
            "event": "pipeline_complete",
            "status": result.status.value,
            "total_latency_ms": total_ms,
        })
    else:
        logger.error("pipeline_complete", extra={
            "event": "pipeline_complete",
            "status": result.status.value,
            "total_latency_ms": total_ms,
            "error": result.message,
        })
    return result


def _run_pipeline(question: str) -> PipelineResult:
    result = PipelineResult(question=question)
    semantic_schema = get_semantic_schema()

    result = _generate_sql(result, semantic_schema)
    if result.status != Status.OK:
        return result

    result.is_safe, result.message = _validate_sql(result.sql)
    if not result.is_safe:
        result.status = Status.UNSAFE_SQL
        return result

    result = _execute_query(result)
    if result.status != Status.OK:
        return result

    result = _generate_explanation(result)
    return result


def _generate_sql(result: PipelineResult, semantic_schema: dict) -> PipelineResult:
    prompt = build_sql_prompt(result.question, semantic_schema)
    try:
        sql = generate_sql(prompt)
    except le.LLMPipelineError as exc:
        result.status = Status.LLM_ERROR
        result.message = str(exc)
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
        logger.warning("cannot_answer", extra={"event": "cannot_answer", "question": result.question})
        result.status = Status.CANCELLED
        result.message = "LLM indicated it could not answer."
        return result

    return result


def _validate_sql(sql: str) -> tuple[bool, str]:
    if sql is None or sql == "" or sql == "CANNOT_ANSWER":
        return False, "Query cancelled or could not be answered."
    return is_safe_sql(sql)


def _execute_query(result: PipelineResult) -> PipelineResult:
    try:
        result.results = run_query(result.sql)
    except Exception as exc:
        result.status = Status.DB_ERROR
        result.message = f"Database execution failed: {exc}"
    return result


def _generate_explanation(result: PipelineResult) -> PipelineResult:
    try:
        result.explanation = generate_explanation(result.question, result.sql, result.results)
    except Exception as exc:
        result.status = Status.EXPLANATION_ERROR
        result.message = f"Explanation generation failed: {exc}"
    return result
