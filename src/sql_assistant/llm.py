import logging
import time

import openai
from openai import OpenAI
from config.settings import settings
from . import exceptions as le

logger = logging.getLogger(__name__)

_client: OpenAI | None = None

_RETRY_DELAYS = [0, 1, 2, 4]  # delay before each of the 4 attempts
_RETRYABLE_STATUS_CODES = {500, 502, 503, 504}


def _get_client() -> OpenAI:
    global _client
    if _client is None:
        _client = OpenAI(api_key=settings.openai_api_key)
    return _client


def _is_retryable(exc: Exception) -> bool:
    if isinstance(exc, (openai.RateLimitError, openai.APIConnectionError)):
        return True
    if isinstance(exc, openai.APIStatusError):
        return exc.status_code in _RETRYABLE_STATUS_CODES
    return False


def ask_llm(prompt: str) -> str:
    last_exc: Exception | None = None

    for attempt, delay in enumerate(_RETRY_DELAYS, start=1):
        if delay:
            time.sleep(delay)

        try:
            response = _get_client().chat.completions.create(
                model="gpt-4.1-mini",
                messages=[{"role": "user", "content": prompt}],
                temperature=0,
            )
            content = response.choices[0].message.content.strip()

            if not content:
                raise le.LLMEmptyOutput("LLM returned empty content")

            return content

        except le.LLMEmptyOutput:
            raise

        except (openai.AuthenticationError, openai.BadRequestError) as exc:
            raise le.LLMFailed(str(exc)) from exc

        except openai.APIStatusError as exc:
            if exc.status_code not in _RETRYABLE_STATUS_CODES:
                raise le.LLMFailed(str(exc)) from exc
            last_exc = exc
            logger.warning("llm_retry", extra={
                "event": "llm_retry",
                "attempt": attempt,
                "error_type": type(exc).__name__,
                "delay_s": delay,
            })

        except (openai.RateLimitError, openai.APIConnectionError) as exc:
            last_exc = exc
            logger.warning("llm_retry", extra={
                "event": "llm_retry",
                "attempt": attempt,
                "error_type": type(exc).__name__,
                "delay_s": delay,
            })

        except Exception as exc:
            raise le.LLMFailed(str(exc)) from exc

    raise le.LLMFailed(
        f"LLM failed after {len(_RETRY_DELAYS)} attempts: {last_exc}"
    )


def generate_sql(prompt: str) -> str:
    sql = ask_llm(prompt)
    logger.info("sql_generated", extra={"event": "sql_generated", "sql": sql[:200]})
    logger.debug("sql_generated_full", extra={"event": "sql_generated_full", "sql": sql})
    return sql
