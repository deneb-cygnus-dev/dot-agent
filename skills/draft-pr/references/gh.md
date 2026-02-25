# Workflow: Create PR via `gh pr create`

Run the following command with the title and description composed in Steps 2–3:

```bash
gh pr create \
  --title "<conventional-commits title>" \
  --body "$(cat <<'EOF'
<full description>
EOF
)"
```

Add `--draft` if the branch is not yet ready for review.

## Output

Print the PR URL returned by `gh pr create` to the terminal.

---

## Example 1 — `feat(database): add connection pool and health check (Phase 2.1)`

```bash
gh pr create \
  --title "feat(database): add connection pool and health check (Phase 2.1)" \
  --body "$(cat <<'EOF'
## Summary

- Implements **Phase 2.1 (Database Connection)** from the Backend Development Guide
- Introduces `internal/database` package with a `DB` wrapper around `*sql.DB` providing a configured connection pool, context-aware health check, and graceful shutdown
- Adds `github.com/lib/pq v1.11.2` as the PostgreSQL driver
- Achieves **100% statement coverage** via TDD (tests written before production code)
- Extends all design documents with `users`, `user_preferences`, and user-scoped file/directory ownership schemas

## Changes

### Implementation

| File | Description |
|------|-------------|
| `internal/database/postgres.go` | `DB` type, `New`, `Ping`, `Close`, `DB()` accessor, injectable `openDB` var |
| `internal/database/postgres_test.go` | 5 black-box unit tests (package `database_test`) |
| `internal/database/postgres_internal_test.go` | 2 white-box tests with mock driver (package `database`) |
| `go.mod` / `go.sum` | Added `github.com/lib/pq v1.11.2` |

### Documentation

| File | Description |
|------|-------------|
| `docs/features/DATABASE-SCHEMA.md` | New file: full schema reference with Mermaid ER diagram, table definitions, trigger reference, Redis cache key schema, migration layout |
| `docs/implementations/feature-add-database-connection.md` | New file: 5W1H implementation record for Phase 2.1 |
| `docs/markdown-manager-prd.md` | Bumped to v1.5; added `users`, `user_preferences` tables, user-scoped ownership on `files`/`directories`, user-namespaced Redis keys, User and UserPreferences API endpoints, updated ER diagram and project structure |
| `docs/backend-srs.md` | Bumped to v1.1; added §3.1.3–3.1.5 (Users, UserPreferences, ownership), §3.2.4–3.2.5 (new API endpoints), user-namespaced cache keys |
| `docs/frontend-srs.md` | Bumped to v1.1; §3.2.4 updated to DB-backed preferences with localStorage write-through cache |
| `docs/DEVELOPMENT-BACK.md` | Phase 2.1 checkboxes ticked; migrations 000005–000007 added; User/UserPreferences models, repositories, service, and handlers added to Phases 4–7 |
| `docs/DEVELOPMENT-FRONT.md` | Updated "Based on" reference to PRD v1.5, Frontend SRS v1.1 |

## Test Plan

- [x] `go test ./...` passes with no failures across all packages
- [x] `internal/database` coverage: **100%** (`New`, `Ping`, `Close`, `DB` all at 100%)
- [x] TDD workflow followed: `postgres_internal_test.go` written first, verified compile failure (`openDB: undefined`), then production code added to make tests pass
- [ ] Integration tests against a real PostgreSQL 17 instance (deferred to Phase 11 — testcontainers)

## Pool Settings (SRS §3.3.4)

| Setting | Value |
|---------|-------|
| `MaxOpenConns` | 25 |
| `MaxIdleConns` | 5 |
| `ConnMaxLifetime` | 5 minutes |

## Next Steps

- Phase 2.2 — SQL migration files (`000001` → `000007`)
- Phase 2.3 — Migration runner (`internal/database/migrate.go`)

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

---

## Example 2 — `feat(logger): add environment-aware Zap logger utility`

```bash
gh pr create \
  --title "feat(logger): add environment-aware Zap logger utility" \
  --body "$(cat <<'EOF'
## Summary

- Introduces `internal/logger` package with a `New(appEnv string) (*zap.Logger, error)` factory that selects console or JSON output based on environment
- Achieves **100% statement coverage** via 6 table-driven test functions covering valid environments, invalid inputs, log levels, and caller inclusion
- Removes unused `github.com/sirupsen/logrus` dependency and promotes `go.uber.org/zap` from indirect to direct
- Marks **Phase 1.2** checklist items as complete in `docs/DEVELOPMENT.md`

## Changes

| File | Description |
|------|-------------|
| `internal/logger/logger.go` | `New` factory: console logger (debug, colored) for `development`; JSON logger (info, stdout) for `staging` and `production` |
| `internal/logger/logger_test.go` | 6 table-driven tests covering all environment branches, invalid input, and field presence |
| `go.mod` / `go.sum` | Removed `github.com/sirupsen/logrus`; promoted `go.uber.org/zap` to direct dependency via `go mod tidy` |
| `docs/DEVELOPMENT.md` | Phase 1.2 checklist items ticked |

## Test Plan

- [x] `go test ./internal/logger/...` passes with **100% statement coverage**
- [x] `go build ./...` succeeds with no unused import warnings
- [x] `go mod tidy` applied and `go.sum` is consistent

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```
