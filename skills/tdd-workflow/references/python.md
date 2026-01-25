# Python Testing Reference

## Framework

- `pytest` - Primary test framework
- `pytest-cov` - Coverage reporting
- `pytest-asyncio` - Async test support
- `unittest.mock` / `pytest-mock` - Mocking

## File Organization

```text
project/
├── src/
│   └── mypackage/
│       ├── __init__.py
│       ├── service.py
│       └── repository.py
├── tests/
│   ├── conftest.py              # Shared fixtures
│   ├── unit/
│   │   └── test_service.py
│   ├── integration/
│   │   └── test_api.py
│   └── e2e/
│       └── test_flows.py
└── pyproject.toml
```

## Unit Test Pattern

```python
import pytest
from mypackage.service import MarketService

class TestSearchMarkets:
    def test_returns_relevant_markets(self, mock_repo):
        service = MarketService(mock_repo)
        results = service.search("election", limit=10)

        assert len(results) > 0
        assert all("election" in m.name.lower() for m in results)

    def test_handles_empty_query(self, mock_repo):
        service = MarketService(mock_repo)

        with pytest.raises(ValueError, match="query cannot be empty"):
            service.search("", limit=10)

    @pytest.mark.parametrize("limit,expected", [(5, 5), (10, 10), (100, 50)])
    def test_respects_limit(self, mock_repo, limit, expected):
        results = MarketService(mock_repo).search("test", limit=limit)
        assert len(results) <= expected
```

## Integration Test Pattern

```python
import pytest
from fastapi.testclient import TestClient
from mypackage.main import app

@pytest.fixture
def client():
    return TestClient(app)

class TestMarketAPI:
    def test_get_markets_returns_list(self, client):
        response = client.get("/api/markets")

        assert response.status_code == 200
        assert isinstance(response.json()["data"], list)

    def test_create_validates_input(self, client):
        response = client.post("/api/markets", json={"name": ""})
        assert response.status_code == 400
```

## Mocking Pattern

```python
from unittest.mock import Mock, patch, AsyncMock

def test_service_with_mock():
    mock_repo = Mock()
    mock_repo.find_by_id.return_value = Market(id="123", name="Test")

    result = MarketService(mock_repo).get("123")

    assert result.id == "123"
    mock_repo.find_by_id.assert_called_once_with("123")

@patch("mypackage.service.external_api")
def test_with_patch(mock_api):
    mock_api.fetch.return_value = {"data": "test"}
    result = process_external_data()
    assert result == "test"

# Async
async def test_async_service():
    mock_repo = AsyncMock()
    mock_repo.find_by_id.return_value = Market(id="123")
    result = await MarketService(mock_repo).get_async("123")
    assert result.id == "123"
```

## Fixtures (conftest.py)

```python
import pytest
from unittest.mock import Mock

@pytest.fixture
def mock_repo():
    repo = Mock()
    repo.find_all.return_value = [Market(id="1"), Market(id="2")]
    return repo

@pytest.fixture
def db_session():
    session = create_test_session()
    yield session
    session.rollback()
    session.close()
```

## Commands

```bash
# Run all tests
pytest

# With coverage
pytest --cov=src --cov-report=html

# Run specific test
pytest tests/unit/test_service.py::TestSearchMarkets::test_returns_relevant_markets

# Verbose + parallel
pytest -v -n auto

# Run marked tests
pytest -m "not slow"
```

## CI/CD

```yaml
- uses: actions/setup-python@v5
  with:
    python-version: '3.12'
- run: pip install -e ".[test]"
- run: pytest --cov=src --cov-fail-under=80
```
