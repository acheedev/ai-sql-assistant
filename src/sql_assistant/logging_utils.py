import json
import logging
from datetime import datetime, timezone
from pathlib import Path

_PROJECT_ROOT = Path(__file__).parent.parent.parent  # src/sql_assistant/ → src/ → project root

_LOG_RECORD_ATTRS = frozenset({
    'args', 'created', 'exc_info', 'exc_text', 'filename', 'funcName',
    'levelname', 'levelno', 'lineno', 'message', 'module', 'msecs',
    'msg', 'name', 'pathname', 'process', 'processName', 'relativeCreated',
    'stack_info', 'thread', 'threadName', 'taskName', 'event',
})

_logging_configured = False


class _JsonFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        record.message = record.getMessage()
        dt = datetime.fromtimestamp(record.created, tz=timezone.utc)
        ts = dt.strftime('%Y-%m-%dT%H:%M:%S.') + f"{int(record.msecs):03d}Z"
        obj = {
            "timestamp": ts,
            "level": record.levelname,
            "module": record.module,
            "event": record.message,
        }
        for key, val in record.__dict__.items():
            if key not in _LOG_RECORD_ATTRS:
                obj[key] = val
        return json.dumps(obj)


class _HumanFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        record.message = record.getMessage()
        extras = {k: v for k, v in record.__dict__.items() if k not in _LOG_RECORD_ATTRS}
        base = f"[{record.levelname}] {record.module}: {record.message}"
        if extras:
            extra_str = " ".join(f"{k}={v}" for k, v in extras.items())
            return f"{base} | {extra_str}"
        return base


def configure_logging() -> None:
    global _logging_configured
    if _logging_configured:
        return
    _logging_configured = True

    from config.settings import settings

    root = logging.getLogger()
    level = getattr(logging, settings.log_level.upper(), logging.INFO)
    root.setLevel(level)

    stdout_handler = logging.StreamHandler()
    stdout_handler.setFormatter(_HumanFormatter())
    root.addHandler(stdout_handler)

    log_path = _PROJECT_ROOT / settings.log_file
    log_path.parent.mkdir(parents=True, exist_ok=True)
    file_handler = logging.FileHandler(log_path, encoding="utf-8")
    file_handler.setFormatter(_JsonFormatter())
    root.addHandler(file_handler)
