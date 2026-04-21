# add to imports at top


# replace run_pipeline()



# update generate_sql_from_question signature
def generate_sql_from_question(
    result: PipelineResult,
    semantic_schema: dict
) -> PipelineResult:
    """Populate result.sql from user question."""
    prompt = build_sql_prompt(result.question, semantic_schema)
    # rest of function unchanged