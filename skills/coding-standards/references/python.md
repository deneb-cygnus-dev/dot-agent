# Python Standards

## Core Principles

- Beautiful is better than ugly
- Explicit is better than implicit
- Simple is better than complex
- Readability counts
- EAFP over LBYL (Easier to Ask Forgiveness than Permission)

## Naming Conventions

### Variables and Functions

```python
# GOOD: snake_case
user_name = "alice"
total_count = 42
max_retry_attempts = 3

def calculate_total_price(items: list[Item]) -> Decimal:
    pass

def is_valid_email(email: str) -> bool:
    pass

# BAD
userName = "alice"  # Not Pythonic
x = 42              # Unclear
def calc(i):        # Abbreviated
    pass
```

### Classes and Constants

```python
# PascalCase for classes
class UserRepository:
    pass

class ValidationError(Exception):
    pass

# SCREAMING_SNAKE_CASE for constants
MAX_CONNECTIONS = 100
DEFAULT_TIMEOUT_SECONDS = 30

# Leading underscore for private
class User:
    def __init__(self):
        self._internal_state = {}  # Protected
        self.__private_data = []   # Name mangled
```

## Type Hints

### Basic Types

```python
# Modern Python typing (3.10+)
def process_items(items: list[str]) -> dict[str, int]:
    return {item: len(item) for item in items}

def find_user(user_id: int) -> User | None:
    pass

def fetch_data(url: str, timeout: float = 30.0) -> bytes:
    pass
```

### Complex Types

```python
from typing import TypeVar, Protocol, Callable

T = TypeVar("T")

def first(items: list[T]) -> T | None:
    return items[0] if items else None

# Protocol for structural typing
class Readable(Protocol):
    def read(self, n: int = -1) -> bytes: ...

def process_stream(stream: Readable) -> None:
    data = stream.read()

# TypedDict for structured dicts
from typing import TypedDict

class UserDict(TypedDict):
    id: int
    name: str
    email: str
```

## Error Handling

### Exception Handling

```python
# GOOD: Specific exception handling
try:
    result = process_data(data)
except ValidationError as e:
    logger.warning("Validation failed: %s", e)
    return None
except ConnectionError as e:
    logger.error("Connection failed: %s", e)
    raise ServiceUnavailableError from e

# BAD: Bare except or too broad
try:
    result = process_data(data)
except:  # Catches everything
    pass
```

### Custom Exceptions

```python
class AppError(Exception):
    """Base exception for application errors."""
    pass

class ValidationError(AppError):
    def __init__(self, field: str, message: str):
        self.field = field
        self.message = message
        super().__init__(f"{field}: {message}")

class NotFoundError(AppError):
    def __init__(self, resource: str, identifier: str):
        self.resource = resource
        self.identifier = identifier
        super().__init__(f"{resource} '{identifier}' not found")
```

### Context Managers

```python
# Use context managers for resource management
with open("data.txt", "r") as f:
    content = f.read()

# Custom context managers
from contextlib import contextmanager

@contextmanager
def timer(name: str):
    start = time.perf_counter()
    try:
        yield
    finally:
        elapsed = time.perf_counter() - start
        logger.info("%s took %.2fs", name, elapsed)

with timer("data processing"):
    process_large_dataset()
```

## Project Structure

```text
project/
├── src/
│   └── mypackage/
│       ├── __init__.py
│       ├── core/
│       │   ├── models.py
│       │   └── services.py
│       └── api/
│           ├── routes.py
│           └── schemas.py
├── tests/
│   ├── conftest.py
│   └── test_services.py
├── pyproject.toml
└── README.md
```

### Module Organization

```python
# Standard library
import os
from datetime import datetime

# Third-party
import httpx
from pydantic import BaseModel

# Local
from mypackage.core import models

# Module-level constants
DEFAULT_TIMEOUT = 30

# Module-level logger
logger = logging.getLogger(__name__)
```

## Testing

### Pytest Patterns

```python
def test_create_user_with_valid_data_returns_user():
    pass

def test_create_user_with_duplicate_email_raises_error():
    pass
```

### Fixtures

```python
import pytest

@pytest.fixture
def user_service(db_session):
    return UserService(db=db_session)

@pytest.fixture
def temp_file():
    path = Path("test_temp.txt")
    path.write_text("test content")
    yield path
    path.unlink(missing_ok=True)
```

### Parametrized Tests

```python
@pytest.mark.parametrize("input_value,expected", [
    ("hello", 5),
    ("", 0),
    ("hello world", 11),
])
def test_string_length(input_value: str, expected: int):
    assert len(input_value) == expected
```

### Mocking

```python
from unittest.mock import Mock, patch

def test_fetch_user_calls_api():
    mock_client = Mock()
    mock_client.get.return_value = {"id": 1, "name": "Alice"}

    service = UserService(client=mock_client)
    user = service.fetch_user(1)

    mock_client.get.assert_called_once_with("/users/1")
    assert user.name == "Alice"
```

## Code Smells

### Mutable Default Arguments

```python
# BAD: Mutable default
def add_item(item, items=[]):  # Same list reused!
    items.append(item)
    return items

# GOOD: Use None
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

### Wildcard Imports

```python
# BAD
from module import *

# GOOD
from module import specific_function, SpecificClass
```

### Overusing Classes

```python
# BAD: Class with only __init__ and one method
class DataProcessor:
    def __init__(self, data):
        self.data = data

    def process(self):
        return [x * 2 for x in self.data]

# GOOD: Just use a function
def process_data(data):
    return [x * 2 for x in data]
```

### Ignoring Generators

```python
# BAD: Building large list in memory
def get_all_users():
    users = []
    for row in db.fetch_all("SELECT * FROM users"):
        users.append(User.from_row(row))
    return users

# GOOD: Use generator
def get_all_users():
    for row in db.fetch_all("SELECT * FROM users"):
        yield User.from_row(row)
```

## Pythonic Idioms

### Comprehensions

```python
# List comprehension
squares = [x**2 for x in range(10)]
evens = [x for x in numbers if x % 2 == 0]

# Dict comprehension
user_map = {u.id: u for u in users}

# Generator expression for large data
total = sum(x**2 for x in range(1000000))
```

### Unpacking

```python
# Tuple unpacking
x, y = point
first, *rest = items
first, *middle, last = items

# Dictionary unpacking
defaults = {"timeout": 30, "retries": 3}
config = {**defaults, "timeout": 60}
```

### Iteration

```python
# enumerate for index and value
for i, item in enumerate(items):
    print(f"{i}: {item}")

# zip for parallel iteration
for name, score in zip(names, scores):
    print(f"{name}: {score}")

# any/all for boolean checks
if any(user.is_admin for user in users):
    grant_access()

if all(item.is_valid for item in items):
    process_batch(items)
```

### String Formatting

```python
# BAD: Old-style
message = "Hello %s" % name

# BAD: Concatenation
message = "Hello " + name

# GOOD: f-strings
message = f"Hello {name}"

# GOOD: For logging (deferred evaluation)
logger.info("Processing user %s", user_id)
```
