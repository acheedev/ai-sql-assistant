import logging

from .llm import ask_llm

logger = logging.getLogger(__name__)

_MAX_EXPLAIN_ROWS = 20


def build_explanation_prompt(user_question: str, sql: str, results: list[dict]) -> str:
    total = len(results)
    sample = results[:_MAX_EXPLAIN_ROWS]
    count_note = f" (showing {len(sample)} of {total})" if total > _MAX_EXPLAIN_ROWS else f" ({total} rows)"

    return f"""
You are a business data analyst.

A user asked the following question:
{user_question}

The system generated this SQL query:
{sql}

The query returned the following results{count_note}:
{sample}

Your task:
- Summarize the results in 2-4 concise bullet points
- Focus on business insights, not technical details
- Highlight anything notable (top performers, trends, anomalies)
- Do NOT explain SQL
- Do NOT repeat raw data verbatim

Return only bullet points.
""".strip()


def generate_explanation(question: str, sql: str, results: list[dict]) -> str:
    prompt = build_explanation_prompt(question, sql, results)
    explanation = ask_llm(prompt)
    logger.info("explanation_complete", extra={"event": "explanation_complete"})
    return explanation
