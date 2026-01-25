---
name: coding-standards
description: Coding standards, best practices, and patterns. Supports TypeScript/JavaScript, Go, and Python. Use when writing, reviewing, or refactoring code.
---

# Coding Standards & Best Practices

## Language Detection

Identify the project language, then read the corresponding reference file:

| Language | Signals | Reference |
|----------|---------|-----------|
| **TypeScript/JS** | `package.json`, `*.ts/*.tsx` | [typescript.md](./references/typescript.md) |
| **Go** | `go.mod`, `*.go` | [golang.md](./references/golang.md) |
| **Python** | `pyproject.toml`, `*.py` | [python.md](./references/python.md) |

---

## Universal Principles

### 1. Readability First

- Code is read more than written
- Clear variable and function names
- Self-documenting code preferred over comments
- Consistent formatting

### 2. KISS (Keep It Simple)

- Simplest solution that works
- Avoid over-engineering
- No premature optimization
- Easy to understand > clever code

### 3. DRY (Don't Repeat Yourself)

- Extract common logic into functions
- Create reusable components/modules
- Share utilities across modules
- Avoid copy-paste programming

### 4. YAGNI (You Aren't Gonna Need It)

- Don't build features before they're needed
- Avoid speculative generality
- Add complexity only when required
- Start simple, refactor when needed

---

## Universal Naming Guidelines

| Element | Convention | Examples |
|---------|------------|----------|
| Variables | Descriptive, context-appropriate | `userCount`, `user_count` |
| Functions | Verb-noun pattern | `fetchUser`, `validate_email` |
| Booleans | Question form | `isActive`, `hasPermission` |
| Constants | Indicate immutability | `MAX_RETRIES`, `DefaultTimeout` |

---

## Error Handling Principles

1. **Handle errors explicitly** - Never ignore errors
2. **Add context** - Wrap errors with relevant information
3. **Fail fast** - Detect and report errors early
4. **Be specific** - Catch specific errors, not generic ones
5. **Clean up resources** - Use appropriate resource management patterns

---

## Testing Principles

### Test Structure (AAA Pattern)

```text
Arrange - Set up test data and conditions
Act     - Execute the code under test
Assert  - Verify the expected outcome
```

### Test Coverage

- Unit tests for business logic
- Integration tests for component interaction
- E2E tests for critical user flows
- Edge cases and error paths

### Test Naming

- Describe what is being tested
- Include expected behavior
- Indicate the condition

---

## Code Smell Detection

### 1. Long Functions

- Functions > 50 lines likely need splitting
- Extract logical chunks into smaller functions

### 2. Deep Nesting

- > 3 levels of nesting reduces readability
- Use early returns and guard clauses

### 3. Magic Numbers/Strings

- Replace literals with named constants
- Explain the significance of values

### 4. Duplicated Code

- Extract into shared functions
- Use appropriate abstraction

### 5. Large Parameter Lists

- > 3-4 parameters suggests refactoring
- Consider parameter objects or builders

---

## Comments & Documentation

### When to Comment

- Explain **WHY**, not **WHAT**
- Document non-obvious decisions
- Note workarounds and their reasons
- Reference tickets/issues for complex fixes

### When NOT to Comment

- Stating the obvious
- Compensating for bad naming
- Commented-out code (delete it)
- Outdated information

---

## Performance Principles

1. **Measure first** - Don't optimize without data
2. **Optimize bottlenecks** - Focus on critical paths
3. **Avoid premature optimization** - Clarity over micro-optimizations
4. **Know your data structures** - Choose appropriate collections
5. **Minimize allocations** - Reuse objects where appropriate

---

**Remember**: Code quality is not negotiable. Clear, maintainable code enables rapid development and confident refactoring.
