---
name: phase-decide
description: Use when stuck on a decision during building. Reads open questions from the prompt-spec, helps analyze tradeoffs, records the decision with rationale in the Decisions Log, and updates any affected Constraints or Acceptance Criteria.
model: claude-sonnet-4-6
---

# Phase Decide — Resolve a Decision

## When to Activate

- User says "I'm stuck on a decision" or "which approach should we take"
- User invokes `/phase-decide`
- A build session surfaced a fork in the road that needs structured analysis

## Step 1: Load Open Questions

Read the current prompt-spec's Open Questions section. Display all open questions with their context.

| Situation | Action |
|-----------|--------|
| User specifies which question | Use that one |
| Multiple open questions | Ask which to resolve |
| No open questions but user has a new decision | Add it as a question first, then resolve |

## Step 2: Gather Context

Research the decision based on its type:

| Decision Type | Context Sources |
|---------------|-----------------|
| Technical (e.g., "SurrealDB vs Neo4j") | Research pros/cons, read relevant code |
| Product (e.g., "free tier includes export?") | Reference the business plan |
| Architecture (e.g., "monolith vs microservices") | Check constraints, current state, team size |

## Step 3: Present Tradeoff Analysis

Format as a decision table:

```text
Question: SurrealDB vs Neo4j for graph storage?

| Factor        | SurrealDB              | Neo4j Community         |
|---------------|------------------------|-------------------------|
| Dev experience| Multi-model, newer     | Mature, Cypher is well-documented |
| Cost          | Free, embeddable       | Free community edition   |
| Solo-dev fit  | Simpler ops            | More tooling/community   |
| Risk          | Younger project        | Stable, proven           |

Recommendation: SurrealDB — simpler ops for solo dev, embeddable reduces
infrastructure complexity. Reconsider if graph queries become performance-critical.
```

Always include a recommendation with reasoning.

## Step 4: Record the Decision

Ask user to confirm the decision. Then update the prompt-spec:

1. **Add to Decisions Log** with date, decision, and rationale
2. **Remove or mark resolved** in Open Questions

### Rationale Quality Gate (CRITICAL)

Every decision MUST have rationale that answers three questions:

| Question | Purpose |
|----------|---------|
| **Why this choice?** | Positive reason for selecting it |
| **Why not the alternative?** | What you're giving up |
| **When would we reconsider?** | Reversal condition |

GOOD rationale:

```text
"Chose SurrealDB because embeddable = simpler ops for solo dev. Neo4j's
Cypher is more mature but adds operational complexity. Reconsider if
graph queries become performance-critical (> 10k nodes)."
```

BAD rationale:

```text
"SurrealDB seemed better."
```

## Step 5: Cascade the Decision

Check if the decision affects other parts of the prompt-spec:

| Check | Action |
|-------|--------|
| Affects Constraints? | Update constraints (e.g., "MUST use SurrealDB") |
| Affects Acceptance Criteria? | Update criteria (e.g., add "data persists in SurrealDB") |
| Creates new Open Questions? | Add them |

## Verification

- [ ] Decision is recorded in Decisions Log with date and rationale
- [ ] Rationale answers: why this, why not that, when to reconsider
- [ ] Open Question is marked resolved or removed
- [ ] Affected Constraints and Criteria are updated
