---
name: security-review
description: Use this skill when adding authentication, handling user input, working with secrets, creating API endpoints, or implementing payment/sensitive features. Provides comprehensive security checklist and patterns.
---

# Security Review Skill

This skill ensures all code follows security best practices and identifies potential vulnerabilities.

## When to Activate

- Implementing authentication or authorization
- Handling user input or file uploads
- Creating new API endpoints
- Working with secrets or credentials
- Implementing payment features
- Storing or transmitting sensitive data
- Integrating third-party APIs

## Security Checklist

### 1. Secrets Management

#### NEVER Do This

```go
const apiKey = "sk-proj-xxxxx"  // Hardcoded secret
const dbPassword = "password123" // In source code
```

#### ALWAYS Do This

```go
func loadConfig() (*Config, error) {
    apiKey := os.Getenv("OPENAI_API_KEY")
    if apiKey == "" {
        return nil, errors.New("OPENAI_API_KEY not configured")
    }

    dbURL := os.Getenv("DATABASE_URL")
    if dbURL == "" {
        return nil, errors.New("DATABASE_URL not configured")
    }

    return &Config{APIKey: apiKey, DatabaseURL: dbURL}, nil
}
```

#### Verification Steps

- [ ] No hardcoded API keys, tokens, or passwords
- [ ] All secrets in environment variables
- [ ] `.env` files in .gitignore
- [ ] No secrets in git history
- [ ] Production secrets in hosting platform or secret manager

### 2. Input Validation

#### Always Validate User Input

```go
import "github.com/go-playground/validator/v10"

type CreateUserRequest struct {
    Email string `json:"email" validate:"required,email"`
    Name  string `json:"name" validate:"required,min=1,max=100"`
    Age   int    `json:"age" validate:"gte=0,lte=150"`
}

var validate = validator.New()

func (h *Handler) CreateUser(w http.ResponseWriter, r *http.Request) {
    var req CreateUserRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        respondError(w, http.StatusBadRequest, "invalid request body")
        return
    }

    if err := validate.Struct(req); err != nil {
        respondError(w, http.StatusBadRequest, "validation failed")
        return
    }

    // Proceed with validated data
}
```

#### File Upload Validation

```go
func validateFileUpload(header *multipart.FileHeader) error {
    // Size check (5MB max)
    const maxSize = 5 << 20
    if header.Size > maxSize {
        return errors.New("file too large (max 5MB)")
    }

    // Type check via content sniffing
    file, err := header.Open()
    if err != nil {
        return err
    }
    defer file.Close()

    buf := make([]byte, 512)
    if _, err := file.Read(buf); err != nil {
        return err
    }

    contentType := http.DetectContentType(buf)
    allowedTypes := map[string]bool{
        "image/jpeg": true,
        "image/png":  true,
        "image/gif":  true,
    }

    if !allowedTypes[contentType] {
        return errors.New("invalid file type")
    }

    // Extension check
    ext := strings.ToLower(filepath.Ext(header.Filename))
    allowedExts := map[string]bool{".jpg": true, ".jpeg": true, ".png": true, ".gif": true}
    if !allowedExts[ext] {
        return errors.New("invalid file extension")
    }

    return nil
}
```

#### Verification Steps

- [ ] All user inputs validated with schemas
- [ ] File uploads restricted (size, type, extension)
- [ ] No direct use of user input in queries
- [ ] Whitelist validation (not blacklist)
- [ ] Error messages don't leak sensitive info

### 3. SQL Injection Prevention

#### NEVER Concatenate SQL

```go
// DANGEROUS - SQL Injection vulnerability
query := fmt.Sprintf("SELECT * FROM users WHERE email = '%s'", userEmail)
db.Query(query)
```

#### ALWAYS Use Parameterized Queries

```go
// Safe - parameterized query
row := db.QueryRowContext(ctx,
    "SELECT id, name, email FROM users WHERE email = $1",
    userEmail,
)

// With sqlx
var user User
err := db.GetContext(ctx, &user,
    "SELECT * FROM users WHERE email = $1", userEmail)

// GORM (also safe)
db.Where("email = ?", userEmail).First(&user)
```

#### Verification Steps

- [ ] All database queries use parameterized queries
- [ ] No string concatenation/fmt.Sprintf in SQL
- [ ] ORM/query builder used correctly
- [ ] Dynamic column names validated against whitelist

### 4. Authentication & Authorization

#### JWT Token Handling

```go
// CORRECT: httpOnly cookies
func setAuthCookie(w http.ResponseWriter, token string) {
    http.SetCookie(w, &http.Cookie{
        Name:     "token",
        Value:    token,
        HttpOnly: true,
        Secure:   true,
        SameSite: http.SameSiteStrictMode,
        MaxAge:   3600,
        Path:     "/",
    })
}

// Token verification middleware
func AuthMiddleware(verifier *TokenVerifier) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            cookie, err := r.Cookie("token")
            if err != nil {
                http.Error(w, "unauthorized", http.StatusUnauthorized)
                return
            }

            claims, err := verifier.Verify(cookie.Value)
            if err != nil {
                http.Error(w, "invalid token", http.StatusUnauthorized)
                return
            }

            ctx := context.WithValue(r.Context(), userClaimsKey, claims)
            next.ServeHTTP(w, r.WithContext(ctx))
        })
    }
}
```

#### Authorization Checks

```go
func (h *Handler) DeleteUser(w http.ResponseWriter, r *http.Request) {
    claims := MustUserFromContext(r.Context())
    targetID := chi.URLParam(r, "id")

    // ALWAYS verify authorization first
    if claims.Role != "admin" && claims.UserID != targetID {
        http.Error(w, "forbidden", http.StatusForbidden)
        return
    }

    if err := h.userService.Delete(r.Context(), targetID); err != nil {
        h.handleError(w, err)
        return
    }

    w.WriteHeader(http.StatusNoContent)
}
```

#### Row Level Security (PostgreSQL)

```sql
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Users can only view their own data
CREATE POLICY "Users view own data"
  ON users FOR SELECT
  USING (auth.uid() = id);

-- Users can only update their own data
CREATE POLICY "Users update own data"
  ON users FOR UPDATE
  USING (auth.uid() = id);
```

#### Verification Steps

- [ ] Tokens stored in httpOnly cookies (not client storage)
- [ ] Authorization checks before sensitive operations
- [ ] Row Level Security enabled where applicable
- [ ] Role-based access control implemented
- [ ] Session management secure

### 5. XSS Prevention

#### Sanitize User Content

```go
import "github.com/microcosm-cc/bluemonday"

var sanitizer = bluemonday.UGCPolicy()

func sanitizeHTML(input string) string {
    return sanitizer.Sanitize(input)
}

// For strict text only (no HTML)
var strictPolicy = bluemonday.StrictPolicy()

func sanitizeText(input string) string {
    return strictPolicy.Sanitize(input)
}
```

#### Security Headers Middleware

```go
func SecurityHeaders(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Security-Policy",
            "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'")
        w.Header().Set("X-Content-Type-Options", "nosniff")
        w.Header().Set("X-Frame-Options", "DENY")
        w.Header().Set("X-XSS-Protection", "1; mode=block")
        w.Header().Set("Referrer-Policy", "strict-origin-when-cross-origin")
        next.ServeHTTP(w, r)
    })
}
```

#### Verification Steps

- [ ] User-provided HTML sanitized
- [ ] Security headers configured
- [ ] No unvalidated dynamic content in responses
- [ ] JSON responses properly escaped (encoding/json handles this)

### 6. CSRF Protection

#### CSRF Token Middleware

```go
import "github.com/gorilla/csrf"

func setupCSRF(r chi.Router) {
    csrfMiddleware := csrf.Protect(
        []byte(os.Getenv("CSRF_KEY")),
        csrf.Secure(true),
        csrf.HttpOnly(true),
        csrf.SameSite(csrf.SameSiteStrictMode),
    )
    r.Use(csrfMiddleware)
}

// In handlers, get token for forms
func (h *Handler) GetForm(w http.ResponseWriter, r *http.Request) {
    token := csrf.Token(r)
    // Include token in response/form
}
```

#### Verification Steps

- [ ] CSRF tokens on state-changing operations
- [ ] SameSite=Strict on all cookies
- [ ] CSRF middleware enabled

### 7. Rate Limiting

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
            key := r.RemoteAddr // or user ID for authenticated requests

            if !limiter.Allow(key) {
                w.Header().Set("Retry-After", "60")
                http.Error(w, "rate limit exceeded", http.StatusTooManyRequests)
                return
            }

            next.ServeHTTP(w, r)
        })
    }
}

// Different limits for different endpoints
var (
    generalLimiter = NewRateLimiter(100, 10)  // 100 req/s, burst 10
    searchLimiter  = NewRateLimiter(10, 5)    // 10 req/s, burst 5
    authLimiter    = NewRateLimiter(5, 3)     // 5 req/s, burst 3
)
```

#### Verification Steps

- [ ] Rate limiting on all API endpoints
- [ ] Stricter limits on expensive operations
- [ ] IP-based rate limiting
- [ ] User-based rate limiting (authenticated)

### 8. Sensitive Data Exposure

#### Logging

```go
// WRONG: Logging sensitive data
logger.Info("user login", "email", email, "password", password)
logger.Info("payment", "card", cardNumber, "cvv", cvv)

// CORRECT: Redact sensitive data
logger.Info("user login", "email", email, "user_id", userID)
logger.Info("payment", "last4", card.Last4, "user_id", userID)
```

#### Error Handling

```go
// WRONG: Exposing internal details
func handleError(w http.ResponseWriter, err error) {
    http.Error(w, err.Error(), http.StatusInternalServerError) // Leaks details!
}

// CORRECT: Generic error messages
func handleError(w http.ResponseWriter, r *http.Request, err error) {
    requestID := middleware.GetReqID(r.Context())

    // Log full error internally
    logger.Error("request failed",
        "error", err,
        "request_id", requestID,
        "path", r.URL.Path,
    )

    // Return generic message to client
    http.Error(w, "an error occurred", http.StatusInternalServerError)
}
```

#### Verification Steps

- [ ] No passwords, tokens, or secrets in logs
- [ ] Error messages generic for users
- [ ] Detailed errors only in server logs
- [ ] No stack traces exposed to users

### 9. Dependency Security

#### Regular Updates

```bash
# Check for vulnerabilities
go list -m -json all | go run golang.org/x/vuln/cmd/govulncheck@latest

# Or install govulncheck
go install golang.org/x/vuln/cmd/govulncheck@latest
govulncheck ./...

# Update dependencies
go get -u ./...
go mod tidy

# Check for outdated packages
go list -m -u all
```

#### Lock Files

```bash
# ALWAYS commit go.sum
git add go.mod go.sum

# Verify dependencies
go mod verify
```

#### Verification Steps

- [ ] Dependencies up to date
- [ ] No known vulnerabilities (govulncheck clean)
- [ ] go.mod and go.sum committed
- [ ] Dependabot/Renovate enabled
- [ ] Regular security updates

## Security Testing

```go
func TestRequiresAuthentication(t *testing.T) {
    req := httptest.NewRequest("GET", "/api/protected", nil)
    rec := httptest.NewRecorder()

    handler.ServeHTTP(rec, req)

    assert.Equal(t, http.StatusUnauthorized, rec.Code)
}

func TestRequiresAdminRole(t *testing.T) {
    req := httptest.NewRequest("DELETE", "/api/users/123", nil)
    req.Header.Set("Authorization", "Bearer "+userToken) // non-admin token
    rec := httptest.NewRecorder()

    handler.ServeHTTP(rec, req)

    assert.Equal(t, http.StatusForbidden, rec.Code)
}

func TestRejectsInvalidInput(t *testing.T) {
    body := strings.NewReader(`{"email": "not-an-email"}`)
    req := httptest.NewRequest("POST", "/api/users", body)
    req.Header.Set("Content-Type", "application/json")
    rec := httptest.NewRecorder()

    handler.ServeHTTP(rec, req)

    assert.Equal(t, http.StatusBadRequest, rec.Code)
}

func TestEnforcesRateLimits(t *testing.T) {
    var rateLimited int

    for i := 0; i < 101; i++ {
        req := httptest.NewRequest("GET", "/api/endpoint", nil)
        rec := httptest.NewRecorder()
        handler.ServeHTTP(rec, req)

        if rec.Code == http.StatusTooManyRequests {
            rateLimited++
        }
    }

    assert.Greater(t, rateLimited, 0)
}
```

## Pre-Deployment Security Checklist

Before ANY production deployment:

- [ ] **Secrets**: No hardcoded secrets, all in env vars
- [ ] **Input Validation**: All user inputs validated
- [ ] **SQL Injection**: All queries parameterized
- [ ] **XSS**: User content sanitized, security headers set
- [ ] **CSRF**: Protection enabled
- [ ] **Authentication**: Proper token handling (httpOnly cookies)
- [ ] **Authorization**: Role checks in place
- [ ] **Rate Limiting**: Enabled on all endpoints
- [ ] **HTTPS**: Enforced in production
- [ ] **Security Headers**: CSP, X-Frame-Options configured
- [ ] **Error Handling**: No sensitive data in errors
- [ ] **Logging**: No sensitive data logged
- [ ] **Dependencies**: Up to date, no vulnerabilities
- [ ] **CORS**: Properly configured
- [ ] **File Uploads**: Validated (size, type)

## Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Go Security Best Practices](https://go.dev/doc/security/best-practices)
- [govulncheck](https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck)
- [Web Security Academy](https://portswigger.net/web-security)

---

**Remember**: Security is not optional. One vulnerability can compromise the entire platform. When in doubt, err on the side of caution.
