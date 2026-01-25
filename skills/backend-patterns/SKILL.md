---
name: backend-patterns
description: Backend architecture patterns, API design, database optimization, and server-side best practices for Go development.
---

# Go Backend Development Patterns

## API Design Patterns

### RESTful Structure

```go
// Resource-based URLs
// GET    /api/markets           - List
// GET    /api/markets/{id}      - Get
// POST   /api/markets           - Create
// PUT    /api/markets/{id}      - Replace
// PATCH  /api/markets/{id}      - Update
// DELETE /api/markets/{id}      - Delete

r.Route("/api/markets", func(r chi.Router) {
    r.Get("/", s.listMarkets)
    r.Post("/", s.createMarket)
    r.Route("/{id}", func(r chi.Router) {
        r.Get("/", s.getMarket)
        r.Put("/", s.updateMarket)
        r.Delete("/", s.deleteMarket)
    })
})
```

### Repository Pattern

```go
type MarketRepository interface {
    FindAll(ctx context.Context, filters MarketFilters) ([]Market, error)
    FindByID(ctx context.Context, id string) (*Market, error)
    Create(ctx context.Context, market *Market) error
    Update(ctx context.Context, market *Market) error
    Delete(ctx context.Context, id string) error
}

type postgresMarketRepo struct{ db *sql.DB }

func (r *postgresMarketRepo) FindByID(ctx context.Context, id string) (*Market, error) {
    var m Market
    err := r.db.QueryRowContext(ctx,
        `SELECT id, name, status FROM markets WHERE id = $1`, id,
    ).Scan(&m.ID, &m.Name, &m.Status)

    if errors.Is(err, sql.ErrNoRows) {
        return nil, nil
    }
    if err != nil {
        return nil, fmt.Errorf("query market %s: %w", id, err)
    }
    return &m, nil
}
```

### Service Layer

```go
type MarketService struct {
    repo   MarketRepository
    cache  Cache
}

func (s *MarketService) Search(ctx context.Context, query string, limit int) ([]Market, error) {
    embedding, err := s.embedder.Embed(ctx, query)
    if err != nil {
        return nil, fmt.Errorf("generate embedding: %w", err)
    }

    results, err := s.vectorDB.Search(ctx, embedding, limit)
    if err != nil {
        return nil, fmt.Errorf("vector search: %w", err)
    }

    return s.repo.FindByIDs(ctx, extractIDs(results))
}
```

### Middleware

```go
func AuthMiddleware(verifier TokenVerifier) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            token := strings.TrimPrefix(r.Header.Get("Authorization"), "Bearer ")
            if token == "" {
                http.Error(w, `{"error":"unauthorized"}`, http.StatusUnauthorized)
                return
            }

            user, err := verifier.Verify(r.Context(), token)
            if err != nil {
                http.Error(w, `{"error":"invalid token"}`, http.StatusUnauthorized)
                return
            }

            ctx := context.WithValue(r.Context(), userContextKey, user)
            next.ServeHTTP(w, r.WithContext(ctx))
        })
    }
}

// Compose middleware
r.Use(middleware.RequestID)
r.Use(middleware.Logger)
r.Use(middleware.Recoverer)
r.Use(middleware.Timeout(30 * time.Second))
```

### Handler Pattern

```go
func (s *Server) getMarket(w http.ResponseWriter, r *http.Request) {
    market, err := s.marketService.GetByID(r.Context(), chi.URLParam(r, "id"))
    if err != nil {
        s.handleError(w, r, err)
        return
    }
    if market == nil {
        s.respondError(w, http.StatusNotFound, "not found")
        return
    }
    s.respondJSON(w, http.StatusOK, market)
}

func (s *Server) respondJSON(w http.ResponseWriter, status int, data any) {
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(status)
    json.NewEncoder(w).Encode(map[string]any{"success": true, "data": data})
}
```

## Database Patterns

### Query Optimization

```go
// GOOD: Select specific columns
rows, _ := db.QueryContext(ctx,
    `SELECT id, name, status FROM markets WHERE status = $1 LIMIT $2`,
    "active", 10)

// GOOD: Use prepared statements for repeated queries
stmt, _ := db.PrepareContext(ctx, `SELECT id, name FROM markets WHERE status = $1`)
defer stmt.Close()
```

### N+1 Prevention

```go
// BAD: N+1 queries
for i := range markets {
    markets[i].Creator, _ = userRepo.FindByID(ctx, markets[i].CreatorID)
}

// GOOD: Batch fetch
creatorIDs := uniqueIDs(markets, func(m Market) string { return m.CreatorID })
creators, _ := userRepo.FindByIDs(ctx, creatorIDs)
creatorMap := toMap(creators, func(u User) string { return u.ID })

for i := range markets {
    markets[i].Creator = creatorMap[markets[i].CreatorID]
}
```

### Transactions

```go
func WithTx(ctx context.Context, db *sql.DB, fn func(tx *sql.Tx) error) error {
    tx, err := db.BeginTx(ctx, nil)
    if err != nil {
        return err
    }
    defer func() {
        if p := recover(); p != nil {
            tx.Rollback()
            panic(p)
        }
    }()

    if err := fn(tx); err != nil {
        tx.Rollback()
        return err
    }
    return tx.Commit()
}

// Usage
err := WithTx(ctx, db, func(tx *sql.Tx) error {
    if _, err := tx.ExecContext(ctx, `INSERT INTO markets ...`); err != nil {
        return err
    }
    if _, err := tx.ExecContext(ctx, `INSERT INTO positions ...`); err != nil {
        return err
    }
    return nil
})
```

### Connection Pool

```go
db.SetMaxOpenConns(25)
db.SetMaxIdleConns(5)
db.SetConnMaxLifetime(5 * time.Minute)
db.SetConnMaxIdleTime(1 * time.Minute)
```

## Caching

### Cache-Aside with Singleflight

```go
import "golang.org/x/sync/singleflight"

type MarketCache struct {
    redis *redis.Client
    repo  MarketRepository
    sf    singleflight.Group
    ttl   time.Duration
}

func (c *MarketCache) Get(ctx context.Context, id string) (*Market, error) {
    key := "market:" + id

    // Try cache
    if data, err := c.redis.Get(ctx, key).Bytes(); err == nil {
        var m Market
        json.Unmarshal(data, &m)
        return &m, nil
    }

    // Singleflight prevents cache stampede
    result, err, _ := c.sf.Do(key, func() (any, error) {
        market, err := c.repo.FindByID(ctx, id)
        if err != nil {
            return nil, err
        }
        if market != nil {
            data, _ := json.Marshal(market)
            c.redis.Set(ctx, key, data, c.ttl)
        }
        return market, nil
    })

    if err != nil {
        return nil, err
    }
    return result.(*Market), nil
}
```

## Error Handling

### Domain Errors

```go
var (
    ErrNotFound     = errors.New("not found")
    ErrUnauthorized = errors.New("unauthorized")
    ErrForbidden    = errors.New("forbidden")
)

type ValidationError struct {
    Field   string `json:"field"`
    Message string `json:"message"`
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("%s: %s", e.Field, e.Message)
}
```

### Centralized Handler

```go
func (s *Server) handleError(w http.ResponseWriter, r *http.Request, err error) {
    switch {
    case errors.Is(err, ErrNotFound):
        s.respondError(w, http.StatusNotFound, "not found")
    case errors.Is(err, ErrUnauthorized):
        s.respondError(w, http.StatusUnauthorized, "unauthorized")
    case errors.Is(err, ErrForbidden):
        s.respondError(w, http.StatusForbidden, "forbidden")
    default:
        s.logger.Error("unexpected error", "error", err, "path", r.URL.Path)
        s.respondError(w, http.StatusInternalServerError, "internal error")
    }
}
```

### Retry with Backoff

```go
func WithRetry[T any](ctx context.Context, maxAttempts int, fn func() (T, error)) (T, error) {
    var zero T
    var lastErr error

    for i := 0; i < maxAttempts; i++ {
        if result, err := fn(); err == nil {
            return result, nil
        } else {
            lastErr = err
        }

        if i < maxAttempts-1 {
            delay := time.Duration(1<<uint(i)) * time.Second // 1s, 2s, 4s...
            select {
            case <-ctx.Done():
                return zero, ctx.Err()
            case <-time.After(delay):
            }
        }
    }
    return zero, fmt.Errorf("max retries: %w", lastErr)
}
```

## Authentication & Authorization

### JWT Validation

```go
type Claims struct {
    UserID string `json:"user_id"`
    Role   string `json:"role"`
    jwt.RegisteredClaims
}

func (v *TokenVerifier) Verify(ctx context.Context, token string) (*Claims, error) {
    parsed, err := jwt.ParseWithClaims(token, &Claims{}, func(t *jwt.Token) (any, error) {
        if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
            return nil, fmt.Errorf("unexpected signing method: %v", t.Header["alg"])
        }
        return v.secret, nil
    })
    if err != nil {
        return nil, err
    }

    claims, ok := parsed.Claims.(*Claims)
    if !ok || !parsed.Valid {
        return nil, errors.New("invalid token")
    }
    return claims, nil
}
```

### RBAC

```go
type Permission string

const (
    PermRead   Permission = "read"
    PermWrite  Permission = "write"
    PermDelete Permission = "delete"
)

var rolePerms = map[string][]Permission{
    "admin": {PermRead, PermWrite, PermDelete},
    "user":  {PermRead, PermWrite},
}

func RequirePermission(perm Permission) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            claims := MustUserFromContext(r.Context())
            if !slices.Contains(rolePerms[claims.Role], perm) {
                http.Error(w, `{"error":"forbidden"}`, http.StatusForbidden)
                return
            }
            next.ServeHTTP(w, r)
        })
    }
}
```

## Rate Limiting

```go
import "golang.org/x/time/rate"

type RateLimiter struct {
    limiters sync.Map
    rate     rate.Limit
    burst    int
}

func (l *RateLimiter) Allow(key string) bool {
    limiter, _ := l.limiters.LoadOrStore(key, rate.NewLimiter(l.rate, l.burst))
    return limiter.(*rate.Limiter).Allow()
}

func RateLimitMiddleware(limiter *RateLimiter) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            if !limiter.Allow(r.RemoteAddr) {
                http.Error(w, `{"error":"rate limit exceeded"}`, http.StatusTooManyRequests)
                return
            }
            next.ServeHTTP(w, r)
        })
    }
}
```

## Background Jobs

### Worker Pool

```go
type Job interface {
    Execute(ctx context.Context) error
}

type WorkerPool struct {
    jobs chan Job
    wg   sync.WaitGroup
}

func NewWorkerPool(workers, queueSize int) *WorkerPool {
    p := &WorkerPool{jobs: make(chan Job, queueSize)}
    for i := 0; i < workers; i++ {
        p.wg.Add(1)
        go p.worker()
    }
    return p
}

func (p *WorkerPool) worker() {
    defer p.wg.Done()
    for job := range p.jobs {
        ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
        if err := job.Execute(ctx); err != nil {
            log.Printf("job failed: %v", err)
        }
        cancel()
    }
}

func (p *WorkerPool) Submit(job Job)  { p.jobs <- job }
func (p *WorkerPool) Shutdown()       { close(p.jobs); p.wg.Wait() }
```

### Graceful Shutdown

```go
func main() {
    srv := &http.Server{Addr: ":8080", Handler: router}

    go func() {
        if err := srv.ListenAndServe(); err != http.ErrServerClosed {
            log.Fatal(err)
        }
    }()

    quit := make(chan os.Signal, 1)
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    <-quit

    ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()

    srv.Shutdown(ctx)
    pool.Shutdown()
    db.Close()
}
```

## Logging

| Library | Use Case |
|---------|----------|
| `log/slog` | New projects (Go 1.21+), standard library |
| `logrus` | Rich ecosystem, hooks for external services |
| `zerolog` | High-performance, zero allocation |

### slog (Standard Library)

```go
logger := slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
    Level: slog.LevelInfo,
}))

logger.Info("request completed",
    "method", r.Method,
    "path", r.URL.Path,
    "status", status,
    "duration_ms", elapsed.Milliseconds(),
)
```

### Logrus

```go
import "github.com/sirupsen/logrus"

logger := logrus.New()
logger.SetFormatter(&logrus.JSONFormatter{})

logger.WithFields(logrus.Fields{
    "method":   r.Method,
    "path":     r.URL.Path,
    "status":   status,
}).Info("request completed")

// With error
logger.WithError(err).Error("operation failed")
```

## Health & Metrics

```go
func (s *Server) healthCheck(w http.ResponseWriter, r *http.Request) {
    ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
    defer cancel()

    checks := map[string]string{"database": "healthy", "redis": "healthy"}
    status := http.StatusOK

    if err := s.db.PingContext(ctx); err != nil {
        checks["database"] = "unhealthy"
        status = http.StatusServiceUnavailable
    }
    if err := s.redis.Ping(ctx).Err(); err != nil {
        checks["redis"] = "unhealthy"
        status = http.StatusServiceUnavailable
    }

    w.WriteHeader(status)
    json.NewEncoder(w).Encode(checks)
}
```

```go
// Prometheus metrics
var httpRequests = prometheus.NewCounterVec(
    prometheus.CounterOpts{Name: "http_requests_total"},
    []string{"method", "path", "status"},
)

var httpDuration = prometheus.NewHistogramVec(
    prometheus.HistogramOpts{Name: "http_request_duration_seconds"},
    []string{"method", "path"},
)

r.Handle("/metrics", promhttp.Handler())
```

**Remember**: Choose patterns that match your complexity. Start simple, add abstraction when needed.
