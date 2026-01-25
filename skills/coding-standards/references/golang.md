# Go Standards

## Core Principles

- Go favors explicit over implicit
- Clear is better than clever
- A little copying is better than a little dependency
- Composition over inheritance

## Naming Conventions

### Packages

```go
// GOOD: Short, lowercase, no underscores
package http
package json
package userservice

// BAD
package httpServer
package user_service
```

### Variables

```go
// GOOD: Short names in small scopes
for i, v := range items {
    process(v)
}

// GOOD: Descriptive names in larger scopes
var userRepository *Repository
var maxConnectionRetries = 3

// Acronyms: all caps or all lowercase
var httpClient *http.Client  // GOOD
var userID string            // GOOD
var userId string            // BAD
```

### Functions

```go
// GOOD: Verb or verb-noun for actions
func CreateUser(name string) (*User, error) { }
func ValidateEmail(email string) bool { }

// GOOD: Noun for getters (no "Get" prefix)
func (u *User) Name() string { return u.name }
func (u *User) IsActive() bool { return u.active }
```

### Interfaces

```go
// GOOD: -er suffix for single-method interfaces
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Validator interface {
    Validate() error
}

// GOOD: Descriptive names for larger interfaces
type UserRepository interface {
    Create(ctx context.Context, user *User) error
    FindByID(ctx context.Context, id string) (*User, error)
    Delete(ctx context.Context, id string) error
}
```

## Error Handling

### Basic Pattern

```go
// GOOD: Always check errors
result, err := doSomething()
if err != nil {
    return fmt.Errorf("failed to do something: %w", err)
}

// BAD: Never ignore errors
result, _ := doSomething()
```

### Error Wrapping

```go
func ProcessOrder(orderID string) error {
    order, err := fetchOrder(orderID)
    if err != nil {
        return fmt.Errorf("process order %s: %w", orderID, err)
    }
    return nil
}

// Check for specific errors
if errors.Is(err, ErrNotFound) {
    return nil, ErrOrderNotFound
}

// Extract error types
var validationErr *ValidationError
if errors.As(err, &validationErr) {
    return nil, fmt.Errorf("validation failed: %s", validationErr.Field)
}
```

### Custom Errors

```go
// Sentinel errors
var (
    ErrNotFound     = errors.New("not found")
    ErrUnauthorized = errors.New("unauthorized")
)

// Custom error types
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation error on %s: %s", e.Field, e.Message)
}
```

## Concurrency

### Goroutines with Context

```go
func processItems(ctx context.Context, items []Item) error {
    for _, item := range items {
        select {
        case <-ctx.Done():
            return ctx.Err()
        default:
            if err := process(item); err != nil {
                return err
            }
        }
    }
    return nil
}
```

### WaitGroup Pattern

```go
func processInParallel(items []Item) error {
    var wg sync.WaitGroup
    errCh := make(chan error, len(items))

    for _, item := range items {
        wg.Add(1)
        go func(item Item) {
            defer wg.Done()
            if err := process(item); err != nil {
                errCh <- err
            }
        }(item)
    }

    wg.Wait()
    close(errCh)

    for err := range errCh {
        if err != nil {
            return err
        }
    }
    return nil
}
```

### Channels

```go
// Producer pattern
func producer(ctx context.Context) <-chan int {
    ch := make(chan int)
    go func() {
        defer close(ch)
        for i := 0; ; i++ {
            select {
            case <-ctx.Done():
                return
            case ch <- i:
            }
        }
    }()
    return ch
}
```

### Sync Patterns

```go
// sync.Once for initialization
var (
    instance *Service
    once     sync.Once
)

func GetService() *Service {
    once.Do(func() {
        instance = &Service{}
    })
    return instance
}

// RWMutex for read-heavy workloads
type Cache struct {
    mu    sync.RWMutex
    items map[string]Item
}

func (c *Cache) Get(key string) (Item, bool) {
    c.mu.RLock()
    defer c.mu.RUnlock()
    item, ok := c.items[key]
    return item, ok
}
```

## Project Structure

```text
project/
├── cmd/
│   └── myapp/
│       └── main.go           # Entry point
├── internal/
│   ├── domain/               # Business logic
│   ├── repository/           # Data access
│   └── service/              # Application services
├── pkg/                      # Public libraries
├── api/                      # API definitions
├── go.mod
└── go.sum
```

### Package by Feature

```go
// GOOD: Package by feature/domain
internal/
├── user/
│   ├── handler.go
│   ├── service.go
│   └── repository.go
└── order/
    ├── handler.go
    └── service.go

// AVOID: Package by layer (circular dependencies)
internal/
├── handlers/
├── services/
└── repositories/
```

## Testing

### Table-Driven Tests

```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive numbers", 2, 3, 5},
        {"negative numbers", -2, -3, -5},
        {"zeros", 0, 0, 0},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Add(%d, %d) = %d; want %d",
                    tt.a, tt.b, result, tt.expected)
            }
        })
    }
}
```

### Test Helpers

```go
func assertNoError(t *testing.T, err error) {
    t.Helper()
    if err != nil {
        t.Fatalf("unexpected error: %v", err)
    }
}
```

## Code Smells

### Naked Returns

```go
// BAD
func split(sum int) (x, y int) {
    x = sum * 4 / 9
    y = sum - x
    return  // Confusing
}

// GOOD
func split(sum int) (int, int) {
    x := sum * 4 / 9
    y := sum - x
    return x, y
}
```

### Complex Init Functions

```go
// AVOID
func init() {
    db, err := sql.Open("postgres", connectionString)
    if err != nil {
        panic(err)  // Hard to test
    }
}

// GOOD: Explicit initialization
func NewApp(config Config) (*App, error) {
    db, err := sql.Open("postgres", config.DatabaseURL)
    if err != nil {
        return nil, fmt.Errorf("open database: %w", err)
    }
    return &App{db: db}, nil
}
```

### Interface Pollution

```go
// BAD: Defining interfaces prematurely
type UserServiceInterface interface {
    CreateUser(user *User) error
    GetUser(id string) (*User, error)
    // ... 20 more methods
}

// GOOD: Accept interfaces, return structs
// Define interfaces where they are used
type UserCreator interface {
    CreateUser(user *User) error
}

func NewHandler(users UserCreator) *Handler {
    return &Handler{users: users}
}
```

## Performance

### Preallocate Slices

```go
// GOOD
items := make([]Item, 0, len(input))
for _, v := range input {
    items = append(items, transform(v))
}

// BAD: Growing slice repeatedly
var items []Item
for _, v := range input {
    items = append(items, transform(v))
}
```

### String Building

```go
// GOOD
var builder strings.Builder
for _, s := range parts {
    builder.WriteString(s)
}
result := builder.String()

// BAD
var result string
for _, s := range parts {
    result += s  // Creates new string each iteration
}
```
