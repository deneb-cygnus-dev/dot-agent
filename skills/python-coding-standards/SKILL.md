---
name: python-coding-standards
description: Coding standards, best practices, and patterns for Python development following PEP 8 and Pythonic idioms.
---

# Python Coding Standards & Best Practices

Pythonic coding standards applicable across all Python projects.

## Code Quality Principles

### 1. The Zen of Python

- Beautiful is better than ugly
- Explicit is better than implicit
- Simple is better than complex
- Readability counts
- There should be one obvious way to do it

### 2. PEP 8 Compliance

- Follow PEP 8 style guide
- Use consistent formatting (black, ruff)
- Maximum line length of 88-120 characters
- Use meaningful whitespace

### 3. Duck Typing with Type Hints

- "If it walks like a duck and quacks like a duck..."
- Add type hints for documentation and tooling
- Don't over-constrain with types
- Use Protocol for structural typing

### 4. EAFP Over LBYL

- Easier to Ask for Forgiveness than Permission
- Use try/except rather than checking preconditions
- Pythonic error handling

## Naming Conventions

### Variables and Functions

```python
# GOOD: snake_case for variables and functions
user_name = "alice"
total_count = 42
max_retry_attempts = 3

def calculate_total_price(items: list[Item]) -> Decimal:
    pass

def is_valid_email(email: str) -> bool:
    pass

# BAD: camelCase or unclear names
userName = "alice"  # Not Pythonic
x = 42              # Unclear
def calc(i):        # Abbreviated
    pass
```

### Classes and Constants

```python
# GOOD: PascalCase for classes
class UserRepository:
    pass

class HTTPClient:
    pass

class ValidationError(Exception):
    pass

# GOOD: SCREAMING_SNAKE_CASE for constants
MAX_CONNECTIONS = 100
DEFAULT_TIMEOUT_SECONDS = 30
API_BASE_URL = "https://api.example.com"

# GOOD: Leading underscore for private
class User:
    def __init__(self):
        self._internal_state = {}  # Protected
        self.__private_data = []   # Name mangled
```

### Module and Package Names

```python
# GOOD: Short, lowercase, no underscores preferred
# mypackage/
#   __init__.py
#   utils.py
#   validators.py

import mypackage
from mypackage import utils

# AVOID: Underscores in package names (ok in modules)
# my_package/  # Less preferred
```

## Type Hints

### Basic Type Hints

```python
# GOOD: Modern Python typing (3.10+)
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
from collections.abc import Iterator, Mapping

# Generic types
T = TypeVar("T")

def first(items: list[T]) -> T | None:
    return items[0] if items else None

# Protocol for structural typing
class Readable(Protocol):
    def read(self, n: int = -1) -> bytes: ...

def process_stream(stream: Readable) -> None:
    data = stream.read()
    # ...

# Callable types
Handler = Callable[[Request], Response]

def register_handler(path: str, handler: Handler) -> None:
    pass

# TypedDict for structured dicts
from typing import TypedDict

class UserDict(TypedDict):
    id: int
    name: str
    email: str
    active: bool
```

### Type Aliases

```python
# GOOD: Type aliases for complex types
UserId = int
JsonDict = dict[str, Any]
Callback = Callable[[str, int], None]

def get_user(user_id: UserId) -> JsonDict:
    pass

# Python 3.12+ type statement
type Point = tuple[float, float]
type Matrix = list[list[float]]
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
except:  # Catches everything including KeyboardInterrupt
    pass

try:
    result = process_data(data)
except Exception:  # Too broad
    pass
```

### Custom Exceptions

```python
# GOOD: Custom exception hierarchy
class AppError(Exception):
    """Base exception for application errors."""
    pass

class ValidationError(AppError):
    """Raised when input validation fails."""
    def __init__(self, field: str, message: str):
        self.field = field
        self.message = message
        super().__init__(f"{field}: {message}")

class NotFoundError(AppError):
    """Raised when a resource is not found."""
    def __init__(self, resource: str, identifier: str):
        self.resource = resource
        self.identifier = identifier
        super().__init__(f"{resource} '{identifier}' not found")

# Usage
def get_user(user_id: str) -> User:
    user = db.find_user(user_id)
    if user is None:
        raise NotFoundError("User", user_id)
    return user
```

### Context Managers

```python
# GOOD: Use context managers for resource management
with open("data.txt", "r") as f:
    content = f.read()

with db.transaction() as tx:
    tx.execute("INSERT INTO users ...")
    tx.execute("INSERT INTO audit_log ...")

# GOOD: Create custom context managers
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

### Source Layout

```text
project/
├── src/
│   └── mypackage/
│       ├── __init__.py
│       ├── core/
│       │   ├── __init__.py
│       │   ├── models.py
│       │   └── services.py
│       ├── api/
│       │   ├── __init__.py
│       │   ├── routes.py
│       │   └── schemas.py
│       └── utils/
│           ├── __init__.py
│           └── helpers.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   ├── test_models.py
│   └── test_services.py
├── pyproject.toml
├── README.md
└── .gitignore
```

### Module Organization

```python
# GOOD: Clear imports at top, organized
# Standard library
import os
import sys
from datetime import datetime
from pathlib import Path

# Third-party
import httpx
from pydantic import BaseModel

# Local
from mypackage.core import models
from mypackage.utils.helpers import format_date

# Module-level constants
DEFAULT_TIMEOUT = 30
MAX_RETRIES = 3

# Module-level logger
logger = logging.getLogger(__name__)


# Class and function definitions follow
class UserService:
    pass
```

## Testing

### Pytest Patterns

```python
# GOOD: Clear test naming
def test_create_user_with_valid_data_returns_user():
    pass

def test_create_user_with_duplicate_email_raises_error():
    pass

def test_get_user_with_nonexistent_id_returns_none():
    pass
```

### Fixtures

```python
import pytest

@pytest.fixture
def user_service(db_session):
    """Provide a configured UserService instance."""
    return UserService(db=db_session)

@pytest.fixture
def sample_user():
    """Provide a sample user for testing."""
    return User(
        id=1,
        name="Test User",
        email="test@example.com"
    )

# Fixture with cleanup
@pytest.fixture
def temp_file():
    """Provide a temporary file that's cleaned up after test."""
    path = Path("test_temp.txt")
    path.write_text("test content")
    yield path
    path.unlink(missing_ok=True)
```

### Parametrized Tests

```python
import pytest

@pytest.mark.parametrize("input_value,expected", [
    ("hello", 5),
    ("", 0),
    ("hello world", 11),
    ("  spaces  ", 10),
])
def test_string_length(input_value: str, expected: int):
    assert len(input_value) == expected

@pytest.mark.parametrize("email,is_valid", [
    ("user@example.com", True),
    ("user@sub.example.com", True),
    ("invalid", False),
    ("@example.com", False),
    ("user@", False),
])
def test_email_validation(email: str, is_valid: bool):
    assert validate_email(email) == is_valid
```

### Mocking

```python
from unittest.mock import Mock, patch, MagicMock

def test_fetch_user_calls_api():
    mock_client = Mock()
    mock_client.get.return_value = {"id": 1, "name": "Alice"}

    service = UserService(client=mock_client)
    user = service.fetch_user(1)

    mock_client.get.assert_called_once_with("/users/1")
    assert user.name == "Alice"

@patch("mypackage.services.httpx.get")
def test_external_api_call(mock_get):
    mock_get.return_value = Mock(
        status_code=200,
        json=lambda: {"data": "test"}
    )

    result = fetch_external_data()

    assert result == {"data": "test"}
```

## Code Smells & Anti-Patterns

### 1. Mutable Default Arguments

```python
# BAD: Mutable default argument
def add_item(item, items=[]):  # Same list reused!
    items.append(item)
    return items

# GOOD: Use None as default
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

### 2. Wildcard Imports

```python
# BAD: Pollutes namespace, unclear dependencies
from module import *

# GOOD: Explicit imports
from module import specific_function, SpecificClass
```

### 3. Using `type()` for Type Checking

```python
# BAD: Doesn't handle inheritance
if type(obj) == list:
    pass

# GOOD: Use isinstance
if isinstance(obj, list):
    pass

# GOOD: Check for protocol/interface
if hasattr(obj, "__iter__"):
    pass
```

### 4. Overusing Classes

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

### 5. Ignoring Generator Opportunities

```python
# BAD: Building large list in memory
def get_all_users():
    users = []
    for row in db.fetch_all("SELECT * FROM users"):
        users.append(User.from_row(row))
    return users

# GOOD: Use generator for memory efficiency
def get_all_users():
    for row in db.fetch_all("SELECT * FROM users"):
        yield User.from_row(row)
```

### 6. String Formatting Anti-Patterns

```python
# BAD: Old-style formatting
message = "Hello %s, you have %d messages" % (name, count)

# BAD: Concatenation
message = "Hello " + name + ", you have " + str(count) + " messages"

# GOOD: f-strings (Python 3.6+)
message = f"Hello {name}, you have {count} messages"

# GOOD: For logging (deferred evaluation)
logger.info("Processing user %s with %d items", user_id, item_count)
```

## Pythonic Idioms

### Comprehensions

```python
# GOOD: List comprehension
squares = [x**2 for x in range(10)]
evens = [x for x in numbers if x % 2 == 0]

# GOOD: Dict comprehension
user_map = {u.id: u for u in users}

# GOOD: Set comprehension
unique_names = {u.name.lower() for u in users}

# GOOD: Generator expression for large data
total = sum(x**2 for x in range(1000000))
```

### Unpacking

```python
# GOOD: Tuple unpacking
x, y = point
first, *rest = items
first, *middle, last = items

# GOOD: Dictionary unpacking
defaults = {"timeout": 30, "retries": 3}
config = {**defaults, "timeout": 60}  # Override timeout
```

### Context and Iteration

```python
# GOOD: enumerate for index and value
for i, item in enumerate(items):
    print(f"{i}: {item}")

# GOOD: zip for parallel iteration
for name, score in zip(names, scores):
    print(f"{name}: {score}")

# GOOD: dict.items() for key-value iteration
for key, value in config.items():
    print(f"{key} = {value}")

# GOOD: Use any/all for boolean checks
if any(user.is_admin for user in users):
    grant_access()

if all(item.is_valid for item in items):
    process_batch(items)
```

### Property Decorators

```python
class Circle:
    def __init__(self, radius: float):
        self._radius = radius

    @property
    def radius(self) -> float:
        return self._radius

    @radius.setter
    def radius(self, value: float) -> None:
        if value < 0:
            raise ValueError("Radius cannot be negative")
        self._radius = value

    @property
    def area(self) -> float:
        """Computed property."""
        return 3.14159 * self._radius ** 2
```

**Remember**: Write code that is Pythonic, readable, and maintainable. Follow the principle of least surprise.
