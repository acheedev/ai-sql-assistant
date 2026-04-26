import asyncio
import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.responses import JSONResponse
from openai import OpenAI
from pydantic import BaseModel

from config.settings import settings
from .db import run_query
from .logging_utils import configure_logging
from .pipeline import Status, run

logger = logging.getLogger(__name__)

_STATUS_TO_HTTP: dict[Status, int] = {
    Status.OK: 200,
    Status.QUESTION_ERROR: 422,
    Status.UNSAFE_SQL: 422,
    Status.CANCELLED: 422,
    Status.DB_ERROR: 502,
    Status.LLM_ERROR: 502,
    Status.EXPLANATION_ERROR: 502,
}


class QueryRequest(BaseModel):
    question: str


class QueryResponse(BaseModel):
    request_id: str
    status: str
    sql: str | None = None
    is_safe: bool | None = None
    row_count: int | None = None
    explanation: str | None = None
    message: str | None = None
    results: list[dict] | None = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    configure_logging()
    yield


app = FastAPI(
    title="AI SQL Assistant",
    version="1.0.0",
    lifespan=lifespan,
)

# TODO: API key middleware goes here (Sprint 2+)


@app.post("/query", response_model=QueryResponse)
async def query(request: QueryRequest, include_results: bool = False) -> JSONResponse:
    result = await asyncio.to_thread(run, request.question)

    response = QueryResponse(
        request_id=result.request_id,
        status=result.status.value,
    )

    if result.status == Status.OK:
        response.sql = result.sql
        response.is_safe = result.is_safe
        response.row_count = len(result.results)
        response.explanation = result.explanation
        if include_results:
            response.results = result.results
    else:
        response.message = result.message

    http_code = _STATUS_TO_HTTP.get(result.status, 500)
    return JSONResponse(content=response.model_dump(mode="json"), status_code=http_code)


@app.get("/health")
async def health() -> JSONResponse:
    db_status = "ok"
    try:
        await asyncio.wait_for(
            asyncio.to_thread(run_query, "SELECT 1 FROM DUAL"),
            timeout=2.0,
        )
    except asyncio.TimeoutError:
        logger.error("health_db_timeout", extra={"event": "health_db_timeout"})
        db_status = "error: could not connect to database"
    except Exception as exc:
        logger.error("health_db_error", extra={"event": "health_db_error", "error": str(exc)})
        db_status = "error: could not connect to database"

    llm_status = "ok"
    try:
        if not settings.openai_api_key:
            llm_status = "error: API key not configured"
        else:
            OpenAI(api_key=settings.openai_api_key)
    except Exception as exc:
        logger.error("health_llm_error", extra={"event": "health_llm_error", "error": str(exc)})
        llm_status = "error: LLM client initialization failed"

    overall = "ok" if db_status == "ok" and llm_status == "ok" else "degraded"
    status_code = 200 if overall == "ok" else 503
    return JSONResponse(
        content={"status": overall, "db": db_status, "llm": llm_status},
        status_code=status_code,
    )
