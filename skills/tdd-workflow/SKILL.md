---
name: tdd-workflow
description: Use this skill when writing new features, fixing bugs, or refactoring code. Enforces test-driven development with 80%+ coverage. Supports Go, Python, TypeScript/JavaScript, and Flutter/Dart.
---

# Test-Driven Development Workflow

## Language Detection

Identify the project language, then read the corresponding reference file:

| Language | Signals | Reference |
|----------|---------|-----------|
| **Go** | `go.mod`, `*.go` | [go.md](./references/go.md) |
| **Python** | `pyproject.toml`, `*.py` | [python.md](./references/python.md) |
| **TypeScript/JS** | `package.json`, `*.ts/*.tsx` | [typescript.md](./references/typescript.md) |
| **Flutter/Dart** | `pubspec.yaml`, `*.dart` | [flutter.md](./references/flutter.md) |

---

## Core TDD Principles

### 1. Tests BEFORE Code

ALWAYS write tests first, then implement code to make tests pass.

### 2. Coverage Requirements

- Minimum 80% coverage (unit + integration + E2E)
- All edge cases covered
- Error scenarios tested
- Boundary conditions verified

### 3. Test Types

| Type | Scope | Speed | Examples |
|------|-------|-------|----------|
| **Unit** | Single function/class | Fast (<50ms) | Pure functions, utilities |
| **Integration** | Multiple components | Medium | API endpoints, DB operations |
| **E2E** | Full user flows | Slow | Browser automation |

---

## TDD Workflow (RED-GREEN-REFACTOR)

### Step 1: Write User Stories

```text
As a [role], I want to [action], so that [benefit]
```

### Step 2: Generate Test Cases

- Happy path (expected behavior)
- Edge cases (empty, null, boundary)
- Error cases (invalid input, failures)

### Step 3: Write Tests (RED)

Write tests that define expected behavior. Tests should fail initially.

### Step 4: Implement Code (GREEN)

Write minimal code to make tests pass. No more, no less.

### Step 5: Refactor (REFACTOR)

Improve code quality while keeping tests green.

### Step 6: Verify Coverage

Ensure 80%+ coverage before completing the feature.

---

## Best Practices

1. **One Assert Per Test** - Focus on single behavior
2. **Descriptive Test Names** - Explain what's being tested
3. **Arrange-Act-Assert** - Clear test structure
4. **Mock External Dependencies** - Isolate unit tests
5. **Test Edge Cases** - Null, empty, boundary values
6. **Test Error Paths** - Not just happy paths
7. **Keep Tests Fast** - Unit tests < 50ms each
8. **Independent Tests** - No test should depend on another
9. **Clean Up After Tests** - No side effects
10. **Test Behavior, Not Implementation** - Avoid brittle tests

---

## Coverage Thresholds

| Metric | Minimum |
|--------|---------|
| Lines | 80% |
| Branches | 80% |
| Functions | 80% |

---

## Success Metrics

- 80%+ code coverage achieved
- All tests passing
- No skipped tests
- Fast execution (unit < 50ms each)
- E2E covers critical flows

---

**Remember**: Tests are not optional. They enable confident refactoring and production reliability.
