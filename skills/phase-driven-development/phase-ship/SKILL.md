---
name: phase-ship
description: Use when all acceptance criteria for the current phase are met. Verifies completion, asks the kill/proceed question, extracts learnings into a learnings.md that feeds the next phase's prompt-spec.
model: claude-sonnet-4-6
---

# Phase Ship — Close a Completed Phase

## When to Activate

- User says "this phase is done" or "let's ship"
- User invokes `/phase-ship`
- All acceptance criteria are met and it's time to close the phase

## Step 1: Verify All Acceptance Criteria Are Met

Run the same check as `/phase-review` Step 2. Check every criterion.

| Result | Action |
|--------|--------|
| All criteria MET | Proceed to Step 2 |
| Any criterion NOT MET | **Refuse to ship:** "Cannot ship — criterion X is not met. Run `/phase-review` first." |

## Step 2: Verify All Constraints Are Satisfied

Check each constraint against the current codebase.

| Result | Action |
|--------|--------|
| All constraints SATISFIED | Proceed to Step 3 |
| Any constraint VIOLATED | **Refuse to ship:** "Cannot ship — constraint X is violated." |

## Step 3: Check Open Questions

If open questions remain:

```text
These questions are still open:
  1. SurrealDB vs Neo4j for Phase 1?

Can they be deferred to the next phase, or must they be resolved first?
```

| User says | Action |
|-----------|--------|
| Defer | Mark as deferred, proceed |
| Must resolve | Run `/phase-decide` first, then return |

## Step 4: Ask the Kill/Proceed Question

This is the most important decision in PDD:

```text
Phase 0: Extraction Validation is complete.

Based on what you learned:
  1. PROCEED to Phase 1 — the approach works, continue building
  2. PIVOT — the approach works but the direction should change
  3. KILL — the core assumption was invalidated, stop this product

Which? (This is the most important decision in PDD.)
```

Record the answer.

## Step 5: Extract Learnings

Ask the user **all five questions** (MUST ask all five):

1. **"What assumptions were correct?"**
2. **"What assumptions were wrong?"**
3. **"What was harder than expected?"**
4. **"What was easier than expected?"**
5. **"What should the next phase know that isn't obvious?"**

Each answer feeds a section of the learnings document.

## Step 6: Generate `learnings.md`

Write to `phases/{phase-name}/learnings.md`:

```markdown
# Phase N Learnings: {Phase Name}

## Outcome
{PROCEED / PIVOT / KILL} — {one-sentence reason}

## Duration
Started: {date} | Completed: {date} | Duration: {N days}

## Assumptions Validated
- {assumption}: {evidence}

## Assumptions Invalidated
- {assumption}: {what actually happened}

## Surprises
- {thing that was harder/easier than expected}: {why}

## Recommendations for Next Phase
- {concrete recommendation}

## Decisions That Carry Forward
| Decision | Rationale | Still Valid? |
|----------|-----------|--------------|
| {decision from this phase} | {original rationale} | {yes/no/needs review} |
```

## Step 7: Mark Phase Complete

- Add header to the prompt-spec: `> STATUS: COMPLETE — {date}`
- Update the Decisions Log with the ship decision (PROCEED/PIVOT/KILL)

## Verification

- [ ] All acceptance criteria are met
- [ ] All constraints are satisfied
- [ ] Kill/proceed decision is recorded
- [ ] `learnings.md` exists with all 5 learning sections filled
- [ ] User was asked all 5 learning questions
- [ ] Phase is marked COMPLETE in prompt-spec
