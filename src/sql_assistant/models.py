from enum import Enum

from pydantic import BaseModel, ConfigDict, Field


class Status(str, Enum):
    OK                = "OK"
    QUESTION_ERROR    = "QUESTION_ERROR"
    CANCELLED         = "CANCELLED"
    UNSAFE_SQL        = "UNSAFE_SQL"
    DB_ERROR          = "DB_ERROR"
    LLM_ERROR         = "LLM_ERROR"
    EXPLANATION_ERROR = "EXPLANATION_ERROR"


class QueryRequest(BaseModel):
    question: str = Field(
        ...,
        min_length=1,
        description="Natural language question to answer from the database.",
        examples=["Show me open orders placed in the last 30 days"],
    )


class QueryResponse(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    request_id:  str               = Field(description="UUID identifying this request. Use to correlate API responses to log entries.")
    status:      Status            = Field(description="Pipeline result. One of: OK, QUESTION_ERROR, CANCELLED, UNSAFE_SQL, DB_ERROR, LLM_ERROR, EXPLANATION_ERROR.")
    sql:         str | None        = Field(default=None, description="Generated SQL. None on all error paths.")
    is_safe:     bool | None       = Field(default=None, description="True if the validator passed the SQL. None on all error paths.")
    row_count:   int | None        = Field(default=None, description="Number of rows returned. None on error paths.")
    explanation: str | None        = Field(default=None, description="Plain-English summary of the results. None on error paths.")
    message:     str | None        = Field(default=None, description="Human-readable error detail. Populated on non-OK status only.")
    results:     list[dict] | None = Field(default=None, description="Raw result rows. Only populated when include_results=true is passed on the request.")
