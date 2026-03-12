---
name: phase-kick
description: Use when starting a new development phase. Reads the business plan and previous phase learnings, generates a prompt-spec with Intent, Constraints, Acceptance Criteria, Open Questions, and Decisions Log. Ensures criteria are verifiable before building begins.
argument-hint: "[product-name] [phase-description]"
model: claude-sonnet-4-6
---

# Phase Kick — Start a New Phase

## When to Activate

- User says "I'm starting a new phase" or "let's kick off phase N"
- User invokes `/phase-kick`
- A previous phase was just shipped and the next phase needs to begin

## Step 1: Parse Arguments

If arguments are provided, extract:

- **Product name** — matches a subdirectory under `business/`
- **Phase description** — free text describing what this phase is about

If no arguments, proceed to Step 2 and ask the user.

## Step 2: Locate the Business Plan

Search for `business/*/business-plan.md` in the project.

| Situation | Action |
|-----------|--------|
| Found one business plan | Use it |
| Found multiple | Ask user which product |
| Found none | Ask user to provide the path or describe the phase goal verbally |

## Step 3: Locate Previous Phase Learnings

Search for `phases/*/learnings.md` files, sorted by directory name.

| Situation | Action |
|-----------|--------|
| Previous `learnings.md` found | Read the most recent one — incorporate into constraints and decisions |
| No learnings (Phase 0) | Skip this step |

## Step 4: Extract Phase Information

Find the roadmap/phases section of the business plan. Identify the target phase and extract:

- Phase goals and deliverables
- Timeline estimate
- Relevant constraints (tech stack, budget, compliance)

If the phase isn't clear from the arguments, ask the user which phase to start.

## Step 5: Generate the Prompt-Spec

Use the template at `../references/prompt-spec-template.md`. Fill in each section:

### Intent (2-5 sentences)

Must answer four questions:

| Question | Example |
|----------|---------|
| WHO is the user? | "A fiction writer using the CLI" |
| WHAT can they do? | "Parse a novel into structured character data" |
| WHY does it matter? | "Kill-or-proceed gate for the product" |
| CEILING (out of scope)? | "No UI, no database, no web server" |

### Current State

- Branch name convention: `phase-{n}/{phase-name}`
- List existing file paths, or "nothing exists yet"
- Runnable artifact if any

### Constraints

Sources for constraints:

1. Business plan (tech stack, budget, compliance)
2. Previous phase learnings (what went wrong → new MUST NOT rules)
3. Standard guardrails (security, testing)

Every prompt-spec MUST have at least one security constraint and one architecture constraint.

### Acceptance Criteria

Convert business plan deliverables into verifiable outcomes. Each criterion must pass the **30-second check test**: can someone verify this in 30 seconds?

GOOD criteria:

```text
- [ ] CLI takes .md file path, outputs JSON with characters array containing name and first_appearance fields
- [ ] 70%+ accuracy on こころ (JP) — measured by comparing output to manual annotation
- [ ] Runs in < 60 seconds for 100k words
```

BAD criteria:

```text
- [ ] Extraction works well                    ← vague, not verifiable
- [ ] Use Go structs for the data model        ← implementation-prescriptive, not an outcome
- [ ] System is performant                     ← unmeasurable
```

### Open Questions

Extract unresolved questions from the business plan relevant to this phase.

### Decisions Log

Pre-populate with relevant decisions from the business plan or previous phase learnings.

## Step 6: Challenge the Acceptance Criteria

For EACH criterion, ask: **"How would you verify this in 30 seconds?"**

Flag any criterion that is:

- Vague ("works well", "is fast")
- Unmeasurable ("is performant", "is secure")
- Implementation-prescriptive ("use X library", "write Y struct")

Rewrite flagged criteria with the user before proceeding.

## Step 7: Write the Prompt-Spec

- Create directory: `phases/{phase-name}/`
- Write file: `phases/{phase-name}/prompt-spec.md`
- **Confirm with user before writing**

## Step 8: Suggest First Build Action

Identify the highest-risk or most-uncertain acceptance criterion and recommend tackling it first:

```text
"I recommend starting with criterion X because it has the highest uncertainty.
If this doesn't work, we'll know early and can pivot."
```

## Example Output

See `../references/examples/narragraph-phase-0.md` for a complete prompt-spec example.

## Verification

- [ ] `phases/{phase-name}/prompt-spec.md` exists
- [ ] Intent is 2-5 sentences with WHO, WHAT, WHY, CEILING
- [ ] Every acceptance criterion is verifiable in 30 seconds
- [ ] Constraints include at least one security and one architecture guardrail
- [ ] Previous phase learnings are incorporated (if previous phase exists)
- [ ] User has confirmed the prompt-spec before proceeding
