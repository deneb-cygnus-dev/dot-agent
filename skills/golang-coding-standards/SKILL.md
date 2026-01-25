---
name: golang-coding-standards
description: Coding standards, best practices, and patterns for Go development following idiomatic Go principles.
---

# Go Coding Standards & Best Practices

Idiomatic Go coding standards applicable across all Go projects.

## Code Quality Principles

### 1. Simplicity and Clarity

- Go favors explicit over implicit
- Clear is better than clever
- A little copying is better than a little dependency
- Avoid unnecessary abstractions

### 2. Composition Over Inheritance

- Use interfaces for behavior abstraction
- Embed types for code reuse
- Prefer small, focused interfaces
- Design for composition

### 3. Error Handling is Not Optional

- Always handle errors explicitly
- Errors are values, not exceptions
- Wrap errors with context
- Fail fast, fail clearly

### 4. Concurrency is Not Parallelism

- Don't communicate by sharing memory; share memory by communicating
- Use goroutines for concurrent tasks
- Channels for coordination
- sync primitives for shared state

## Naming Conventions

### Package Names

```go
// GOOD: Short, lowercase, no underscores
package http
package json
package userservice

// BAD: Long, mixed case, or underscores
package httpServer
package user_service
package MyPackage
```

### Variable Names

```go
// GOOD: Short names in small scopes
for i, v := range items {
    process(v)
}

// GOOD: Descriptive names in larger scopes
var userRepository *Repository
var maxConnectionRetries = 3

// BAD: Unnecessarily long names in small scopes
for index, value := range items {
    process(value)
}

// Acronyms should be all caps or all lowercase
var httpClient *http.Client  // GOOD
var userID string            // GOOD
var userId string            // BAD
var HTTPClient *http.Client  // BAD (unless exported)
```

### Function Names

```go
// GOOD: Verb or verb-noun for actions
func CreateUser(name string) (*User, error) { }
func ValidateEmail(email string) bool { }
func (u *User) Save() error { }

// GOOD: Noun for getters (no "Get" prefix)
func (u *User) Name() string { return u.name }
func (u *User) IsActive() bool { return u.active }

// BAD: Redundant "Get" prefix
func (u *User) GetName() string { return u.name }
```

### Interface Names

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

### Basic Error Handling

```go
// GOOD: Always check errors
result, err := doSomething()
if err != nil {
    return fmt.Errorf("failed to do something: %w", err)
}

// BAD: Ignoring errors
result, _ := doSomething()  // Never do this
```

### Error Wrapping

```go
// GOOD: Add context when wrapping errors
func ProcessOrder(orderID string) error {
    order, err := fetchOrder(orderID)
    if err != nil {
        return fmt.Errorf("process order %s: %w", orderID, err)
    }

    if err := validateOrder(order); err != nil {
        return fmt.Errorf("process order %s: %w", orderID, err)
    }

    return nil
}

// GOOD: Check for specific errors
if errors.Is(err, ErrNotFound) {
    return nil, ErrOrderNotFound
}

// GOOD: Extract error types
var validationErr *ValidationError
if errors.As(err, &validationErr) {
    return nil, fmt.Errorf("validation failed: %s", validationErr.Field)
}
```

### Custom Error Types

```go
// GOOD: Sentinel errors for expected conditions
var (
    ErrNotFound     = errors.New("not found")
    ErrUnauthorized = errors.New("unauthorized")
    ErrInvalidInput = errors.New("invalid input")
)

// GOOD: Custom error types for rich error information
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation error on %s: %s", e.Field, e.Message)
}
```

## Concurrency

### Goroutines

```go
// GOOD: Use context for cancellation
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

// GOOD: Wait for goroutines to complete
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
// GOOD: Use channels for communication
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

// GOOD: Use buffered channels when appropriate
results := make(chan Result, workerCount)

// BAD: Unbounded goroutine creation
for _, item := range items {
    go process(item)  // No control over concurrency
}
```

### Sync Patterns

```go
// GOOD: Use sync.Once for initialization
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

// GOOD: Use sync.Mutex for shared state
type Counter struct {
    mu    sync.Mutex
    count int
}

func (c *Counter) Increment() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.count++
}

// GOOD: Use RWMutex for read-heavy workloads
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

### Standard Layout

```text
project/
├── cmd/
│   └── myapp/
│       └── main.go           # Application entry point
├── internal/
│   ├── domain/               # Business logic
│   │   ├── user.go
│   │   └── order.go
│   ├── repository/           # Data access
│   │   └── user_repository.go
│   └── service/              # Application services
│       └── user_service.go
├── pkg/                      # Public libraries
│   └── validator/
│       └── validator.go
├── api/                      # API definitions (OpenAPI, protobuf)
├── configs/                  # Configuration files
├── scripts/                  # Build and utility scripts
├── go.mod
├── go.sum
└── README.md
```

### Package Organization

```go
// GOOD: Package by feature/domain
internal/
├── user/
│   ├── handler.go
│   ├── service.go
│   ├── repository.go
│   └── user.go
└── order/
    ├── handler.go
    ├── service.go
    └── order.go

// AVOID: Package by layer (leads to circular dependencies)
internal/
├── handlers/
├── services/
├── repositories/
└── models/
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
        {"mixed numbers", -2, 3, 1},
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

### Test Naming

```go
// GOOD: Descriptive test function names
func TestUserService_CreateUser_Success(t *testing.T) { }
func TestUserService_CreateUser_DuplicateEmail(t *testing.T) { }
func TestUserService_CreateUser_InvalidInput(t *testing.T) { }

// GOOD: Subtest names describe the scenario
t.Run("returns error when email already exists", func(t *testing.T) { })
t.Run("creates user with valid input", func(t *testing.T) { })
```

### Test Helpers

```go
// GOOD: Use t.Helper() for test helpers
func assertNoError(t *testing.T, err error) {
    t.Helper()
    if err != nil {
        t.Fatalf("unexpected error: %v", err)
    }
}

func assertEqual[T comparable](t *testing.T, got, want T) {
    t.Helper()
    if got != want {
        t.Errorf("got %v; want %v", got, want)
    }
}

// GOOD: Use testify for complex assertions
import "github.com/stretchr/testify/assert"

func TestSomething(t *testing.T) {
    assert.Equal(t, expected, actual)
    assert.NoError(t, err)
    assert.Contains(t, slice, element)
}
```

## Code Smells & Anti-Patterns

### 1. Naked Returns

```go
// BAD: Naked returns are confusing
func split(sum int) (x, y int) {
    x = sum * 4 / 9
    y = sum - x
    return  // What is being returned?
}

// GOOD: Explicit returns
func split(sum int) (int, int) {
    x := sum * 4 / 9
    y := sum - x
    return x, y
}
```

### 2. Init Functions

```go
// AVOID: Complex init functions
func init() {
    db, err := sql.Open("postgres", connectionString)
    if err != nil {
        panic(err)  // Hard to test, debug
    }
    globalDB = db
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

### 3. Interface Pollution

```go
// BAD: Defining interfaces prematurely
type UserServiceInterface interface {
    CreateUser(user *User) error
    GetUser(id string) (*User, error)
    UpdateUser(user *User) error
    DeleteUser(id string) error
    ListUsers() ([]*User, error)
    // ... 20 more methods
}

// GOOD: Accept interfaces, return structs
// Define interfaces where they are used (consumer side)
type UserCreator interface {
    CreateUser(user *User) error
}

func NewHandler(users UserCreator) *Handler {
    return &Handler{users: users}
}
```

### 4. Context Misuse

```go
// BAD: Storing request-scoped values in context
ctx = context.WithValue(ctx, "user", user)  // Type-unsafe key

// GOOD: Use typed keys
type contextKey string
const userContextKey contextKey = "user"

func WithUser(ctx context.Context, user *User) context.Context {
    return context.WithValue(ctx, userContextKey, user)
}

func UserFromContext(ctx context.Context) (*User, bool) {
    user, ok := ctx.Value(userContextKey).(*User)
    return user, ok
}
```

### 5. Panic in Libraries

```go
// BAD: Panicking in library code
func MustParse(s string) Time {
    t, err := Parse(s)
    if err != nil {
        panic(err)  // Crashes the caller's application
    }
    return t
}

// GOOD: Return errors and let caller decide
func Parse(s string) (Time, error) {
    // ...
}
```

## Performance Tips

### Preallocate Slices

```go
// GOOD: Preallocate when size is known
items := make([]Item, 0, len(input))
for _, v := range input {
    items = append(items, transform(v))
}

// BAD: Growing slice repeatedly
var items []Item
for _, v := range input {
    items = append(items, transform(v))  // Multiple allocations
}
```

### String Building

```go
// GOOD: Use strings.Builder for concatenation
var builder strings.Builder
for _, s := range parts {
    builder.WriteString(s)
}
result := builder.String()

// BAD: String concatenation in loop
var result string
for _, s := range parts {
    result += s  // Creates new string each iteration
}
```

### Avoid Unnecessary Allocations

```go
// GOOD: Reuse buffers
var bufPool = sync.Pool{
    New: func() interface{} {
        return new(bytes.Buffer)
    },
}

func process(data []byte) {
    buf := bufPool.Get().(*bytes.Buffer)
    defer bufPool.Put(buf)
    buf.Reset()
    // Use buf...
}
```

**Remember**: Write Go code that is simple, readable, and idiomatic. Let the language's design guide your decisions.
