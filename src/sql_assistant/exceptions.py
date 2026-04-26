class LLMPipelineError(Exception):
    """Base class for LLM pipeline errors and violations."""
    pass

class LLMFailed(LLMPipelineError):
    pass

class LLMEmptyOutput(LLMPipelineError):
    pass

class LLMCannotAnswer(LLMPipelineError):
    pass

class LLMUnsafeSQL(LLMPipelineError):
    pass
