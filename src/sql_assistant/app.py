import os

import pandas as pd
import requests
import streamlit as st

API_BASE = os.getenv("SQL_ASSISTANT_API_URL", "http://localhost:8000")

# ---------------------------------------------------------------------------
# Status → UI treatment
# ---------------------------------------------------------------------------

_BADGE_FN = {
    "OK":                st.success,
    "QUESTION_ERROR":    st.warning,
    "CANCELLED":         st.warning,
    "UNSAFE_SQL":        st.error,
    "DB_ERROR":          st.error,
    "LLM_ERROR":         st.error,
    "EXPLANATION_ERROR": st.warning,
}

_DEFAULT_LABELS = {
    "QUESTION_ERROR":    "This question can't be answered from the available schema.",
    "CANCELLED":         "The query was cancelled or returned no SQL.",
    "UNSAFE_SQL":        "Generated SQL failed safety check.",
    "DB_ERROR":          "Database error. Check logs for request_id.",
    "LLM_ERROR":         "LLM call failed. Check logs for request_id.",
    "EXPLANATION_ERROR": "Results returned but explanation failed.",
}

_SHOW_SQL   = {"OK", "UNSAFE_SQL", "DB_ERROR", "EXPLANATION_ERROR"}
_SHOW_TABLE = {"OK", "EXPLANATION_ERROR"}


# ---------------------------------------------------------------------------
# API call
# ---------------------------------------------------------------------------

def ask(question: str) -> dict:
    try:
        resp = requests.post(
            f"{API_BASE}/query",
            json={"question": question},
            params={"include_results": "true"},
            timeout=30,
        )
        resp.raise_for_status()
        return resp.json()
    except requests.exceptions.ConnectionError:
        return {"_error": "Cannot connect to API. Is the server running?"}
    except requests.exceptions.Timeout:
        return {"_error": "Request timed out (30s). The query may be too complex."}
    except requests.exceptions.HTTPError as e:
        return {"_error": f"API returned {e.response.status_code}."}


# ---------------------------------------------------------------------------
# Rendering
# ---------------------------------------------------------------------------

def _badge_label(status: str, data: dict) -> str:
    message = data.get("message")
    if message:
        return message
    if status == "OK":
        return f"✓ {data.get('row_count', 0)} row(s) returned"
    return _DEFAULT_LABELS.get(status, f"Status: {status}")


def render_response(data: dict) -> None:
    if "_error" in data:
        st.error(data["_error"])
        return

    status = data.get("status", "UNKNOWN")

    # Badge
    badge_fn = _BADGE_FN.get(status, st.info)
    badge_fn(_badge_label(status, data))

    # SQL block
    if status in _SHOW_SQL and data.get("sql"):
        st.code(data["sql"], language="sql")

    # Results table
    if status in _SHOW_TABLE:
        results = data.get("results")
        if results and len(results) > 0:
            st.dataframe(pd.DataFrame(results), width="stretch")
        elif status == "OK":
            st.info("Query returned 0 rows.")

    # Explanation / explanation-error warning
    if status == "OK":
        if data.get("explanation"):
            st.markdown(data["explanation"])
    elif status == "EXPLANATION_ERROR":
        st.warning("Explanation could not be generated for these results.")

    # Footer — always
    st.caption(f"request_id: {data.get('request_id', 'n/a')}")


# ---------------------------------------------------------------------------
# Page
# ---------------------------------------------------------------------------

def main_page() -> None:
    st.title("AI SQL Assistant")
    st.write("Ask a question about the database in plain English.")

    question = st.text_input("Question", placeholder="e.g. Show me open orders placed in the last 30 days")

    if st.button("Ask") and question.strip():
        with st.spinner("Running…"):
            data = ask(question.strip())
        render_response(data)


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main() -> None:
    import subprocess
    import sys
    subprocess.run([sys.executable, "-m", "streamlit", "run", __file__])


main_page()
