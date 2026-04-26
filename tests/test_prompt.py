import pytest
from sql_assistant.prompt import build_sql_prompt


@pytest.fixture
def prompt(minimal_schema):
    return build_sql_prompt("show me open orders", minimal_schema)


def test_prompt_contains_question(prompt):
    assert "show me open orders" in prompt


def test_prompt_marks_preferred_objects(minimal_schema, prompt):
    assert "[PREFERRED]" in prompt


def test_prompt_marks_human_readable_columns(prompt):
    assert "(human-readable)" in prompt


def test_prompt_marks_identifier_columns(prompt):
    assert "(identifier)" in prompt


def test_prompt_marks_filterable_columns(prompt):
    assert "(filterable)" in prompt


def test_prompt_includes_few_shot_examples(minimal_schema, prompt):
    example_sql = minimal_schema["v_order_detail"]["example_questions"][0]["sql"]
    assert example_sql in prompt


def test_prompt_instructs_cannot_answer(prompt):
    assert "CANNOT_ANSWER" in prompt


def test_prompt_contains_oracle_fetch_syntax(prompt):
    assert "FETCH FIRST" in prompt


def test_prompt_instructs_no_trailing_semicolon(prompt):
    assert "Do not add a semicolon" in prompt


def test_prompt_does_not_instruct_to_add_semicolon(prompt):
    lowered = prompt.lower()
    assert "add a semicolon" not in lowered or "do not add a semicolon" in lowered


def test_non_preferred_object_has_no_preferred_tag(minimal_schema):
    schema = dict(minimal_schema)
    schema["v_order_detail"] = dict(schema["v_order_detail"], preferred_for_ai="N")
    p = build_sql_prompt("show me open orders", schema)
    # The instructions always mention [PREFERRED] as a concept; assert the object
    # heading itself does not carry the tag when preferred_for_ai = "N"
    assert "v_order_detail (VIEW) [PREFERRED]" not in p


def test_object_without_examples_omits_examples_section(minimal_schema):
    schema = dict(minimal_schema)
    schema["v_order_detail"] = dict(schema["v_order_detail"], example_questions=[])
    p = build_sql_prompt("show me open orders", schema)
    assert "## Example Questions" not in p
