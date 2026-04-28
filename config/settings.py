from pathlib import Path
from pydantic_settings import BaseSettings, SettingsConfigDict

ROOT = Path(__file__).parent.parent  # config/ → project root

class Settings(BaseSettings):
    openai_api_key: str
    db_user: str
    db_password: str
    db_dsn: str
    log_level: str = "INFO"
    log_file: str = "logs/pipeline.log"
    cache_ttl_seconds: int = 300
    cache_max_size: int = 128

    model_config = SettingsConfigDict(
        env_file=str(ROOT / ".env"),
        env_file_encoding="utf-8"
    )

settings = Settings()