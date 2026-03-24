def build_explanation_prompt(user_question: str, sql: str, results: list[dict]) -> str:
    return f"""
You are a business data analyst.

A user asked the following question:
{user_question}

The system generated this SQL query:
{sql}

The query returned the following results:
{results}

Your task:
- Summarize the results in 2-4 concise bullet points
- Focus on business insights, not technical details
- Highlight anything notable (top performers, trends, anomalies)
- Do NOT explain SQL
- Do NOT repeat raw data verbatim

Return only bullet points.
""".strip()
