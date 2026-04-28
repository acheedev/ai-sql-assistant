import logging
import threading
import time

import pytest

import sql_assistant.cache as cache_mod
from config.settings import settings
from sql_assistant.cache import cache_clear, cache_get, cache_set
from sql_assistant.exceptions import LLMFailed

_VALID_SQL = "SELECT customer_name FROM v_order_detail"
_ROWS = [{"customer_name": "ACME"}]
_EXPLANATION = "One customer found."


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _patch_ttl(mocker, ttl: int, maxsize: int = 16):
    mocker.patch.object(settings, "cache_ttl_seconds", ttl)
    mocker.patch.object(settings, "cache_max_size", maxsize)
    cache_mod._cache = None  # force re-init with patched values


# ---------------------------------------------------------------------------
# Cache disabled (TTL == 0)
# ---------------------------------------------------------------------------

class TestCacheDisabled:

    def test_get_cache_returns_none(self, mocker):
        _patch_ttl(mocker, ttl=0)
        assert cache_mod.get_cache() is None

    def test_cache_get_returns_none(self, mocker):
        _patch_ttl(mocker, ttl=0)
        assert cache_get("any_key") is None

    def test_cache_set_is_noop(self, mocker):
        _patch_ttl(mocker, ttl=0)
        cache_set("key", "value")          # must not raise
        assert cache_get("key") is None    # nothing stored


# ---------------------------------------------------------------------------
# Cache enabled — basic operations
# ---------------------------------------------------------------------------

class TestCacheEnabled:

    def test_set_then_get_returns_value(self, mocker):
        _patch_ttl(mocker, ttl=60)
        cache_set("k", "v")
        assert cache_get("k") == "v"

    def test_get_missing_key_returns_none(self, mocker):
        _patch_ttl(mocker, ttl=60)
        assert cache_get("nonexistent") is None

    def test_ttl_expiry(self, mocker):
        _patch_ttl(mocker, ttl=1)
        cache_set("expiring", "data")
        assert cache_get("expiring") == "data"
        time.sleep(1.1)
        assert cache_get("expiring") is None

    def test_cache_clear(self, mocker):
        _patch_ttl(mocker, ttl=60)
        cache_set("k1", "v1")
        cache_set("k2", "v2")
        cache_clear()
        assert cache_get("k1") is None
        assert cache_get("k2") is None

    def test_max_size_evicts_oldest(self, mocker):
        max_size = 5
        _patch_ttl(mocker, ttl=60, maxsize=max_size)
        for i in range(max_size + 1):
            cache_set(f"key_{i}", f"value_{i}")
        # Oldest entry (key_0) should have been evicted by LRU policy
        assert cache_get("key_0") is None
        assert cache_get(f"key_{max_size}") == f"value_{max_size}"


# ---------------------------------------------------------------------------
# Pipeline integration
# ---------------------------------------------------------------------------

class TestPipelineIntegration:

    def _patch_deps(self, mocker, minimal_schema,
                    sql=_VALID_SQL, sql_side_effect=None,
                    rows=_ROWS, rows_side_effect=None):
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        if sql_side_effect:
            mocker.patch("sql_assistant.pipeline.generate_sql", side_effect=sql_side_effect)
        else:
            mocker.patch("sql_assistant.pipeline.generate_sql", return_value=sql)
        if rows_side_effect:
            mocker.patch("sql_assistant.pipeline.run_query", side_effect=rows_side_effect)
        else:
            mocker.patch("sql_assistant.pipeline.run_query", return_value=rows)
        mocker.patch("sql_assistant.pipeline.generate_explanation", return_value=_EXPLANATION)

    def test_first_call_is_cache_miss(self, mocker, minimal_schema, caplog):
        _patch_ttl(mocker, ttl=60)
        self._patch_deps(mocker, minimal_schema)
        from sql_assistant import pipeline

        with caplog.at_level(logging.DEBUG, logger="sql_assistant.pipeline"):
            pipeline.run("show open orders")

        assert "cache_hit" not in caplog.text
        assert "pipeline_start" in caplog.text

    def test_second_call_is_cache_hit(self, mocker, minimal_schema, caplog):
        _patch_ttl(mocker, ttl=60)
        generate_sql_mock = mocker.patch(
            "sql_assistant.pipeline.generate_sql", return_value=_VALID_SQL
        )
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.run_query", return_value=_ROWS)
        mocker.patch("sql_assistant.pipeline.generate_explanation", return_value=_EXPLANATION)
        from sql_assistant import pipeline

        r1 = pipeline.run("show open orders")

        with caplog.at_level(logging.INFO, logger="sql_assistant.pipeline"):
            r2 = pipeline.run("show open orders")

        assert "cache_hit" in caplog.text
        assert r2.request_id != r1.request_id      # fresh request_id on cache hit
        assert r2.sql == r1.sql                     # same underlying data
        assert r2.explanation == r1.explanation
        assert generate_sql_mock.call_count == 1    # LLM called only once

    def test_normalization_hits_same_cache_entry(self, mocker, minimal_schema):
        _patch_ttl(mocker, ttl=60)
        generate_sql_mock = mocker.patch(
            "sql_assistant.pipeline.generate_sql", return_value=_VALID_SQL
        )
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.run_query", return_value=_ROWS)
        mocker.patch("sql_assistant.pipeline.generate_explanation", return_value=_EXPLANATION)
        from sql_assistant import pipeline

        pipeline.run("show open orders")
        pipeline.run("SHOW OPEN ORDERS  ")   # different casing + trailing space

        assert generate_sql_mock.call_count == 1    # second call was a cache hit

    def test_error_result_not_cached(self, mocker, minimal_schema):
        _patch_ttl(mocker, ttl=60)
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.generate_sql", return_value=_VALID_SQL)
        run_query_mock = mocker.patch(
            "sql_assistant.pipeline.run_query", side_effect=Exception("DB down")
        )
        mocker.patch("sql_assistant.pipeline.generate_explanation", return_value=_EXPLANATION)
        from sql_assistant import pipeline
        from sql_assistant.pipeline import Status

        r1 = pipeline.run("show open orders")
        assert r1.status == Status.DB_ERROR

        r2 = pipeline.run("show open orders")
        assert r2.status == Status.DB_ERROR
        assert run_query_mock.call_count == 2   # pipeline ran twice — error was not cached

    def test_cache_disabled_always_runs_pipeline(self, mocker, minimal_schema, caplog):
        _patch_ttl(mocker, ttl=0)
        generate_sql_mock = mocker.patch(
            "sql_assistant.pipeline.generate_sql", return_value=_VALID_SQL
        )
        mocker.patch("sql_assistant.pipeline.get_semantic_schema", return_value=minimal_schema)
        mocker.patch("sql_assistant.pipeline.run_query", return_value=_ROWS)
        mocker.patch("sql_assistant.pipeline.generate_explanation", return_value=_EXPLANATION)
        from sql_assistant import pipeline

        with caplog.at_level(logging.INFO, logger="sql_assistant.pipeline"):
            pipeline.run("show open orders")
            pipeline.run("show open orders")

        assert generate_sql_mock.call_count == 2   # pipeline ran every time
        assert "cache_hit" not in caplog.text


# ---------------------------------------------------------------------------
# Thread safety
# ---------------------------------------------------------------------------

class TestThreadSafety:

    def test_concurrent_access_no_exceptions(self, mocker):
        _patch_ttl(mocker, ttl=60, maxsize=32)
        errors: list[Exception] = []

        def worker(i: int) -> None:
            try:
                cache_set(f"key_{i}", f"value_{i}")
                cache_get(f"key_{i}")
            except Exception as exc:
                errors.append(exc)

        threads = [threading.Thread(target=worker, args=(i,)) for i in range(10)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()

        assert not errors
