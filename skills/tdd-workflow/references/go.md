# Go Testing Reference

## Framework

- `testing` - Built-in test framework
- `testify` - Assertions and mocking
- `gomock` - Mock generation
- `httptest` - HTTP testing utilities

## File Organization

```text
project/
├── internal/
│   ├── user/
│   │   ├── service.go
│   │   ├── service_test.go      # Unit tests
│   │   └── handler_test.go
│   └── market/
│       ├── repository.go
│       └── repository_test.go
├── integration/
│   └── api_test.go              # Integration tests
└── e2e/
    └── flows_test.go            # E2E tests
```

## Unit Test Pattern (Table-Driven)

```go
func TestSearchMarkets(t *testing.T) {
    tests := []struct {
        name    string
        query   string
        limit   int
        want    []Market
        wantErr bool
    }{
        {
            name:  "returns relevant markets",
            query: "election",
            limit: 10,
            want:  []Market{{ID: "1", Name: "Election 2024"}},
        },
        {
            name:    "handles empty query",
            query:   "",
            wantErr: true,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := svc.Search(context.Background(), tt.query, tt.limit)

            if tt.wantErr {
                assert.Error(t, err)
                return
            }
            assert.NoError(t, err)
            assert.Equal(t, tt.want, got)
        })
    }
}
```

## Integration Test Pattern

```go
func TestMarketAPI(t *testing.T) {
    srv := setupTestServer(t)
    defer srv.Close()

    t.Run("GET /api/markets returns list", func(t *testing.T) {
        resp, err := http.Get(srv.URL + "/api/markets")
        require.NoError(t, err)
        defer resp.Body.Close()

        assert.Equal(t, http.StatusOK, resp.StatusCode)
    })

    t.Run("POST validates input", func(t *testing.T) {
        body := strings.NewReader(`{"name": ""}`)
        resp, _ := http.Post(srv.URL+"/api/markets", "application/json", body)

        assert.Equal(t, http.StatusBadRequest, resp.StatusCode)
    })
}
```

## Mocking Pattern

```go
type MockRepository struct {
    mock.Mock
}

func (m *MockRepository) FindByID(ctx context.Context, id string) (*Market, error) {
    args := m.Called(ctx, id)
    if args.Get(0) == nil {
        return nil, args.Error(1)
    }
    return args.Get(0).(*Market), args.Error(1)
}

func TestServiceWithMock(t *testing.T) {
    mockRepo := new(MockRepository)
    mockRepo.On("FindByID", mock.Anything, "123").Return(&Market{ID: "123"}, nil)

    svc := NewService(mockRepo)
    result, err := svc.Get(context.Background(), "123")

    assert.NoError(t, err)
    assert.Equal(t, "123", result.ID)
    mockRepo.AssertExpectations(t)
}
```

## Commands

```bash
# Run all tests
go test ./...

# With coverage
go test -cover ./...

# Generate HTML report
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out

# Run specific test
go test -run TestSearchMarkets ./internal/market/

# Verbose + race detection
go test -v -race ./...
```

## CI/CD

```yaml
- uses: actions/setup-go@v5
  with:
    go-version: '1.22'
- run: go test -cover -race ./...
```
