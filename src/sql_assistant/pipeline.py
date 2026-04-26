import logging
import time
import uuid
from dataclasses import dataclass, field
from typing import Any

from .models import Status
from .llm import generate_sql
from .prompt import build_sql_prompt
from .validator import is_safe_sql, normalize_sql
from .db import run_query, get_semantic_schema
from .explain import generate_explanation
from . import exceptions as le

logger = logging.getLogger(__name__)


@dataclass
class PipelineResult:
    question: str
    status: Status = Status.OK
    sql: str = ""
    is_safe: bool = False
    message: str = ""
    results: list[Any] = field(default_factory=list)
    explanation: str = ""
    request_id: str = ""

    def to_response(self, include_results: bool = False) -> "QueryResponse":
        from sql_assistant.models import QueryResponse
        return QueryResponse(
            request_id=self.request_id,
            status=self.status,
            sql=self.sql or None,
            is_safe=self.is_safe if self.status == Status.OK else None,
            row_count=len(self.results) if self.results is not None else None,
            explanation=self.explanation or None,
            message=self.message or None,
            results=self.results if include_results else None,
        )

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
    request_id = str(uuid.uuid4())
    start = time.monotonic()
    logger.info("pipeline_start", extra={"event": "pipeline_start", "question": question, "request_id": request_id})

    try:
        result = _run_pipeline(question, request_id)
    except Exception as exc:
        result = PipelineResult(
            question=question,
            request_id=request_id,
            status=Status.DB_ERROR,
            message=f"Unhandled pipeline error: {exc}",
        )

    total_ms = int((time.monotonic() - start) * 1000)
    if result.status == Status.OK:
        logger.info("pipeline_complete", extra={
            "event": "pipeline_complete",
            "status": result.status.value,
            "total_latency_ms": total_ms,
            "request_id": request_id,
        })
    else:
        logger.error("pipeline_complete", extra={
            "event": "pipeline_complete",
            "status": result.status.value,
            "total_latency_ms": total_ms,
            "error": result.message,
            "request_id": request_id,
        })
    return result


def _run_pipeline(question: str, request_id: str) -> PipelineResult:
    result = PipelineResult(question=question, request_id=request_id)
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
        logger.warning("cannot_answer", extra={"event": "cannot_answer", "question": result.question, "request_id": result.request_id})
        result.status = Status.QUESTION_ERROR
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
