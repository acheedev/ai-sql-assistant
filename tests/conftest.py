import pytest


@pytest.fixture(autouse=True)
def clear_cache():
    """Reset cache state before every test to prevent cross-test contamination."""
    import sql_assistant.cache as cache_mod
    cache_mod._cache = None  # force re-init next access (picks up any patched settings)
    yield
    cache_mod._cache = None


@pytest.fixture
def minimal_schema():
    """Minimal schema dict matching the structure returned by get_semantic_schema().
    Values use "Y"/"N" strings to match the Oracle DB format."""
    return {
        "v_order_detail": {
            "object_name": "v_order_detail",
            "object_type": "VIEW",
            "business_name": "Order Detail",
            "short_description": "Detailed view of orders",
            "preferred_for_ai": "Y",
            "default_rank": 1,
            "columns": [
                {
                    "column_name": "order_id",
                    "business_name": "Order ID",
                    "is_identifier": "Y",
                    "is_human_readable": "N",
                    "is_default_select": "N",
                    "is_filterable": "Y",
                    "display_rank": 1,
                },
                {
                    "column_name": "customer_name",
                    "business_name": "Customer Name",
                    "is_identifier": "N",
                    "is_human_readable": "Y",
                    "is_default_select": "Y",
                    "is_filterable": "N",
                    "display_rank": 2,
                },
                {
                    "column_name": "status",
                    "business_name": "Status",
                    "is_identifier": "N",
                    "is_human_readable": "Y",
                    "is_default_select": "Y",
                    "is_filterable": "Y",
                    "display_rank": 3,
                },
            ],
            "aliases": ["orders", "order detail"],
            "example_questions": [
                {
                    "question": "show open orders",
                    "sql": "SELECT customer_name, status FROM v_order_detail WHERE status = 'OPEN'",
                }
            ],
        }
    }
