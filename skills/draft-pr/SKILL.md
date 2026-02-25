---
name: draft-pr
description: Draft a PR title and description for the current branch. Reads the branch diff against main, produces a conventional-commits title and a structured description (The problems / Changes), then saves to pr-draft.md in the project root. Run when ready to open or draft a pull request.
---

# PR Draft Generator

Analyze the current branch diff and generate a concise, conventional PR title and a clear structured description, then save it to `pr-draft.md` in the project root for review or copy-paste into the hosting platform.

## Prerequisites

Before generating the PR draft:

1. **Check current branch**: Must be on a feature/fix branch, not `main` or `master`
2. **Check for changes**: There must be commits that differ from `main`

## Step 1: Gather Branch Information

Run these commands to collect everything needed:

```bash
# Confirm you are not on main/master
git branch --show-current

# High-level summary of what changed
git diff main --stat

# Full diff for detailed analysis
git diff main

# Commit log for this branch
git log main..HEAD --oneline

# Commit details
git log main..HEAD --pretty=format:"%h - %s (%an, %ad)" --date=short
```

## Step 2: Compose the PR Title

Write a **single line** in [Conventional Commits](https://www.conventionalcommits.org/) format:

```text
<type>(<scope>): <short imperative description>
```

### Type reference

| Type | When to use |
|------|-------------|
| `feat` | A new feature or capability |
| `fix` | A bug fix |
| `refactor` | Code restructuring without behavior change |
| `docs` | Documentation only changes |
| `test` | Adding or updating tests |
| `chore` | Tooling, dependencies, CI/CD, config |
| `perf` | Performance improvement |
| `style` | Formatting, linting, whitespace |

### Rules

- **Scope** is optional but encouraged when the change is clearly scoped to a module, package, or layer (e.g., `logger`, `auth`, `api`, `config`)
- **Description** must be lowercase, imperative mood, no trailing period, under 72 characters total
- Drop the scope when the change is cross-cutting or repo-wide

### Examples

```text
feat(logger): add environment-aware Zap logger utility
fix(auth): handle expired JWT tokens on refresh
refactor(config): consolidate env parsing into single loader
docs: add frontend development guide
chore: remove unused logrus dependency
test(logger): add table-driven tests for all environments
```

## Step 3: Compose the PR Description

Write a structured description with exactly two sections.

### Template

```markdown
## The problems

- {Specific problem 1 — what was missing, broken, or inconsistent}
- {Specific problem 2}
- {Add more as needed; omit if only one problem}

## Changes

- {Concrete change 1 — file or component created/modified and what it does}
- {Concrete change 2}
- {Add more as needed}
```

### Writing guidance

**"The problems" section**

- Each bullet describes a real gap, deficiency, or bug that existed *before* this branch
- Be specific: name the file, function, or behavior that was wrong — avoid vague statements like "it didn't work"
- Write in past tense
- If only one root problem exists, use a single bullet

**"Changes" section**

- Each bullet maps to a distinct file, module, or concern that was touched
- Include the file path or component name when relevant (e.g., `internal/logger/logger.go`)
- Describe *what* was added/removed/changed and *why* in a single sentence per bullet
- List dependency updates, config changes, and test additions separately if they are non-trivial

## Step 4: Save the Draft

Save to `pr-draft.md` in the project root.

### File template

```markdown
# PR Draft — {branch-name}

> Generated: {YYYY-MM-DD}

## Title

{conventional commits title}

---

## Description

## The problems

- {problem 1}

## Changes

- {change 1}
```

### Example output file

For branch `feature/add-logger-settings`, the content of `pr-draft.md`:

```markdown
# PR Draft — feature/add-logger-settings

> Generated: 2026-02-25

## Title

feat(logger): add environment-aware Zap logger utility

---

## Description

## The problems

- No centralized logger factory existed, requiring each package to construct its own `*zap.Logger` inline with duplicated environment-switching logic
- Log field names, levels, output destinations, and timestamp formats were inconsistent across construction sites
- `github.com/sirupsen/logrus` was declared as a direct dependency in `go.mod` but never imported anywhere in the codebase
- `go.uber.org/zap` was incorrectly marked as an indirect dependency despite being directly used in `cmd/server/main.go`

## Changes

- Added `internal/logger/logger.go` with a `New(appEnv string) (*zap.Logger, error)` factory that produces a console logger (debug level, colored) for `development` and a JSON logger (info level, stdout) for `staging` and `production`
- Added `internal/logger/logger_test.go` with 6 table-driven test functions covering valid environments, invalid environments, log level behavior, and caller field inclusion — achieving 100% statement coverage
- Removed unused `github.com/sirupsen/logrus` dependency and promoted `go.uber.org/zap` to a direct dependency via `go mod tidy`
- Marked Phase 1.2 checklist items as complete in `docs/DEVELOPMENT.md`
```

---

### Second example

For branch `feature/add-front-end-dev-guide`, the content of `pr-draft.md`:

```markdown
# PR Draft — feature/add-front-end-dev-guide

> Generated: 2026-02-25

## Title

docs: add frontend development guide and fix Node.js version across docs

---

## Description

## The problems

- The frontend had no dedicated implementation guide equivalent to `docs/DEVELOPMENT.md`, leaving developers without a phase-by-phase build plan for the React SPA
- The Node.js build image referenced throughout the docs (`node:20-alpine`) pointed to a Maintenance-only LTS release ending April 2026, with no rationale given for the version choice
- All SRS and development guide documents referenced PRD v1.3, which became stale after the Node.js correction

## Changes

- Added `docs/DEVELOPMENT-FRONT.md`: a 17-phase frontend implementation guide covering project setup, type system, API service layer, Zustand state management, CodeMirror 6 editor, markdown-it preview, file tree virtualization, performance, accessibility, testing (Vitest + Playwright), and deployment
- Updated `docs/markdown-manager-prd.md`: bumped to v1.4, replaced `node:20-alpine` with `node:22-alpine`, and added a v1.4 entry to the Document History table
- Updated `docs/backend-srs.md`, `docs/frontend-srs.md`, and `docs/DEVELOPMENT.md`: corrected all PRD version references from v1.3 to v1.4
```

## Step 5: Validation

Before saving, verify:

- [ ] Branch is not `main` or `master`
- [ ] Title follows conventional commits format and is under 72 characters
- [ ] "The problems" bullets describe *pre-existing* gaps, not the solution
- [ ] "Changes" bullets are concrete and reference actual files or components
- [ ] No sensitive information (secrets, credentials, tokens) in the diff or description

## Output

```text
{project-root}/pr-draft.md
```

After saving, print the title and description to the terminal so the user can copy-paste directly without opening the file.
