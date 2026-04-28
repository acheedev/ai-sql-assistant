import threading

from cachetools import TTLCache

from config.settings import settings

_lock = threading.Lock()
_cache: TTLCache | None = None


def get_cache() -> TTLCache | None:
    """Return the shared TTLCache, or None if caching is disabled (TTL == 0)."""
    global _cache
    if _cache is None and settings.cache_ttl_seconds > 0:
        _cache = TTLCache(
            maxsize=settings.cache_max_size,
            ttl=settings.cache_ttl_seconds,
        )
    return _cache


def cache_get(key: str):
    c = get_cache()
    if c is None:
        return None
    with _lock:
        return c.get(key)


def cache_set(key: str, value) -> None:
    c = get_cache()
    if c is None:
        return
    with _lock:
        c[key] = value


def cache_clear() -> None:
    """Clear all entries. Used in tests."""
    c = get_cache()
    if c is not None:
        with _lock:
            c.clear()
