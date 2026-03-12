---
name: phase-build
description: Use when building within the current phase. Loads the prompt-spec, identifies unmet acceptance criteria, and runs a focused build session targeting the highest-priority unmet criterion. Refuses work outside the prompt-spec scope.
model: claude-sonnet-4-6
---

# Phase Build — Focused Build Session

## When to Activate

- User says "let's build" or "continue building"
- User invokes `/phase-build`
- A phase has been kicked off and there are unmet acceptance criteria

## Step 1: Load the Current Prompt-Spec

Find the active phase: look for `phases/*/prompt-spec.md` where not all acceptance criteria are checked.

| Situation | Action |
|-----------|--------|
| One active phase | Load it |
| Multiple active phases | Ask user which one |
| No active phases | Tell user to run `/phase-kick` first |

Read the full prompt-spec into context.

## Step 2: Identify Unmet Acceptance Criteria

Parse the Acceptance Criteria section. List all criteria marked `- [ ]` (unchecked).

Display to the user:

```text
Unmet criteria:
  1. [ ] CLI takes .md file path → outputs JSON with characters
  2. [ ] 70%+ accuracy on こころ (JP)
  3. [ ] 70%+ accuracy on one English novel
  4. [ ] Runs in < 60 seconds for 100k words
  5. [ ] 5 writers have seen output
```

## Step 3: Select the Target Criterion

| Situation | Action |
|-----------|--------|
| User specifies a criterion | Use that one |
| User doesn't specify | Suggest the highest-priority (highest-risk or blocking others) |

Confirm with the user:

```text
I'll work on: "CLI takes .md file path, outputs JSON with characters array"
This is foundational — all other criteria depend on it.
Confirm? (y/n)
```

## Step 4: Load Constraints

Read the Constraints section. These are **hard rules** for the build session.

Display:

```text
Active constraints for this session:
  - MUST use Claude API structured output (JSON mode)
  - MUST handle UTF-8 CJK
  - MUST NOT build any UI — CLI only
  - Budget: < $5 in API costs
```

## Step 5: Load Decisions Log

Read the Decisions Log. These are **resolved questions** — do NOT re-decide them.

If the build session encounters a situation covered by a past decision, follow it without discussion.

## Step 6: Execute the Build

Build toward the selected criterion. At every point, apply these guards:

### Decision Guard

| Check | Action |
|-------|--------|
| Covered by a Constraint? | Follow the constraint |
| Covered by a Decision? | Follow the decision |
| New decision needed? | Flag for `/phase-decide` or ask the user |

### Scope Creep Guard (CRITICAL)

This is the most important behavior of `/phase-build`. When the user or your own reasoning suggests adding something not in the acceptance criteria:

```text
STOP.
"[Feature X] is not in the current acceptance criteria.
Options:
  1. Add it to the prompt-spec (requires updating acceptance criteria)
  2. Skip it for now (stays out of scope)
  3. Add it to Open Questions for later decision
Which do you prefer?"
```

GOOD behavior:

```text
User: "Let's also add a web UI for the output"
Agent: "A web UI is not in the current acceptance criteria.
       The constraint says MUST NOT build any UI — CLI only.
       Should I add this to Open Questions for a future phase?"
```

BAD behavior:

```text
User: "Let's also add a web UI for the output"
Agent: [silently starts building a web UI]
```

**NEVER silently add features outside the acceptance criteria.**

## Step 7: Update Current State

After the session, update the prompt-spec's Current State section:

```markdown
## Current State

- **Branch:** `phase-0/extraction-validation`
- **Existing files:**
  - `cmd/extract/main.go` — CLI entry point (NEW)
  - `internal/extraction/pipeline.go` — chapter splitting (NEW)
- **Runnable artifact:** `go run cmd/extract/main.go input.md > output.json`
- **Notes:** Basic pipeline working, entity resolution not yet implemented
```

## Verification

- [ ] Prompt-spec was loaded before any coding started
- [ ] Exactly one criterion was targeted per session
- [ ] No code was written outside the acceptance criteria scope
- [ ] Current State was updated after the session
- [ ] All constraints were respected
