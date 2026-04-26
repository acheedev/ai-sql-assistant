import logging
import re

import pytest

from sql_assistant import pipeline
from sql_assistant.pipeline import Status
from sql_assistant.exceptions import LLMFailed

_UUID_RE = re.compile(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    re.IGNORECASE,
)

_VALID_SQL = "SELECT customer_name FROM v_order_detail"
_ROWS = [{"customer_name": "ACME"}]
_EXPLANATION = "One customer found."


def _assert_pipeline_complete(caplog):
    assert any(
        r.getMessage() == "pipeline_complete" for r in caplog.records
    ), "pipeline_complete was not logged"


def _assert_valid_uuid(request_id: str):
    assert _UUID_RE.match(request_id), f"request_id is not a valid UUID: {request_id!r}"


# ---------------------------------------------------------------------------
# All 7 status paths
# ---------------------------------------------------------------------------

class TestStatusPaths:

    def test_ok(self, mocker, minimal_schema, caplog):
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.generate_sql", return_value=_VALID_SQL)
        mocker.patch("sql_assistant.pipeline.run_query", return_value=_ROWS)
        mocker.patch("sql_assistant.pipeline.generate_explanation", return_value=_EXPLANATION)

        with caplog.at_level(logging.DEBUG, logger="sql_assistant.pipeline"):
            result = pipeline.run("show me open orders")

        assert result.status == Status.OK
        assert result.sql == _VALID_SQL
        assert result.is_safe is True
        assert result.results == _ROWS
        assert result.explanation == _EXPLANATION
        _assert_valid_uuid(result.request_id)
        _assert_pipeline_complete(caplog)

    def test_question_error(self, mocker, minimal_schema, caplog):
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.generate_sql", return_value="CANNOT_ANSWER")

        with caplog.at_level(logging.DEBUG, logger="sql_assistant.pipeline"):
            result = pipeline.run("what is the weather in Tokyo")

        assert result.status == Status.QUESTION_ERROR
        _assert_valid_uuid(result.request_id)
        _assert_pipeline_complete(caplog)

    def test_cancelled(self, mocker, minimal_schema, caplog):
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.generate_sql", return_value="")

        with caplog.at_level(logging.DEBUG, logger="sql_assistant.pipeline"):
            result = pipeline.run("show me open orders")

        assert result.status == Status.CANCELLED
        _assert_valid_uuid(result.request_id)
        _assert_pipeline_complete(caplog)

    def test_unsafe_sql(self, mocker, minimal_schema, caplog):
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.generate_sql", return_value="DELETE FROM v_order_detail")

        with caplog.at_level(logging.DEBUG, logger="sql_assistant.pipeline"):
            result = pipeline.run("delete all orders")

        assert result.status == Status.UNSAFE_SQL
        assert result.is_safe is False
        _assert_valid_uuid(result.request_id)
        _assert_pipeline_complete(caplog)

    def test_db_error(self, mocker, minimal_schema, caplog):
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.generate_sql", return_value=_VALID_SQL)
        mocker.patch("sql_assistant.pipeline.run_query", side_effect=Exception("connection refused"))

        with caplog.at_level(logging.DEBUG, logger="sql_assistant.pipeline"):
            result = pipeline.run("show me open orders")

        assert result.status == Status.DB_ERROR
        _assert_valid_uuid(result.request_id)
        _assert_pipeline_complete(caplog)

    def test_llm_error(self, mocker, minimal_schema, caplog):
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.generate_sql", side_effect=LLMFailed("API error"))

        with caplog.at_level(logging.DEBUG, logger="sql_assistant.pipeline"):
            result = pipeline.run("show me open orders")

        assert result.status == Status.LLM_ERROR
        _assert_valid_uuid(result.request_id)
        _assert_pipeline_complete(caplog)

    def test_explanation_error(self, mocker, minimal_schema, caplog):
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.generate_sql", return_value=_VALID_SQL)
        mocker.patch("sql_assistant.pipeline.run_query", return_value=_ROWS)
        mocker.patch("sql_assistant.pipeline.generate_explanation", side_effect=Exception("explanation failed"))

        with caplog.at_level(logging.DEBUG, logger="sql_assistant.pipeline"):
            result = pipeline.run("show me open orders")

        assert result.status == Status.EXPLANATION_ERROR
        _assert_valid_uuid(result.request_id)
        _assert_pipeline_complete(caplog)


# ---------------------------------------------------------------------------
# QUESTION_ERROR vs CANCELLED are distinct triggers
# ---------------------------------------------------------------------------

class TestQuestionErrorVsCancelled:

    def test_cannot_answer_is_question_error(self, mocker, minimal_schema):
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.generate_sql", return_value="CANNOT_ANSWER")
        result = pipeline.run("unanswerable question")
        assert result.status == Status.QUESTION_ERROR

    def test_empty_sql_is_cancelled(self, mocker, minimal_schema):
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.generate_sql", return_value="   ")
        result = pipeline.run("some question")
        assert result.status == Status.CANCELLED

    def test_question_error_and_cancelled_are_different(self, mocker, minimal_schema):
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)

        mocker.patch("sql_assistant.pipeline.generate_sql", return_value="CANNOT_ANSWER")
        r1 = pipeline.run("unanswerable")
        assert r1.status == Status.QUESTION_ERROR

        mocker.patch("sql_assistant.pipeline.generate_sql", return_value="")
        r2 = pipeline.run("empty sql")
        assert r2.status == Status.CANCELLED

        assert r1.status != r2.status


# ---------------------------------------------------------------------------
# request_id uniqueness
# ---------------------------------------------------------------------------

class TestRequestId:

    def test_unique_across_runs(self, mocker, minimal_schema):
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.generate_sql", return_value=_VALID_SQL)
        mocker.patch("sql_assistant.pipeline.run_query", return_value=_ROWS)
        mocker.patch("sql_assistant.pipeline.generate_explanation", return_value=_EXPLANATION)

        r1 = pipeline.run("question one")
        r2 = pipeline.run("question two")

        assert r1.request_id != r2.request_id


# ---------------------------------------------------------------------------
# Regression: get_semantic_schema() failure must not propagate as unhandled
# exception — fixed in S1 by wrapping _run_pipeline() in run()
# ---------------------------------------------------------------------------

class TestS1Regression:

    def test_schema_failure_returns_db_error(self, mocker, caplog):
        mocker.patch(
            "sql_assistant.pipeline.get_semantic_schema",
            side_effect=Exception("TNS: no listener"),
        )

        with caplog.at_level(logging.DEBUG, logger="sql_assistant.pipeline"):
            result = pipeline.run("show me open orders")

        assert result.status == Status.DB_ERROR
        assert "TNS: no listener" in result.message
        _assert_valid_uuid(result.request_id)
        _assert_pipeline_complete(caplog)
