---
name: phase-review
description: Use after a build session to review progress. Checks each acceptance criterion (MET/NOT MET/PARTIAL), verifies constraints, surfaces learnings, and updates the prompt-spec with new decisions and current state.
model: claude-sonnet-4-6
---

# Phase Review — Post-Session Review

## When to Activate

- User says "let's review" or "how did that go"
- User invokes `/phase-review`
- A build session just finished and progress needs to be assessed

## Step 1: Load the Current Prompt-Spec

Find the active phase and read the full prompt-spec.

## Step 2: Check Each Acceptance Criterion

For each criterion, determine its status:

| Status | Symbol | Meaning |
|--------|--------|---------|
| MET | `✓` | Criterion fully satisfied — check the box `- [x]` |
| PARTIALLY MET | `◐` | Some progress — add a note on what's missing |
| NOT MET | `○` | No progress or not tested yet |

Display as a status table:

```text
Acceptance Criteria Status:
  ✓  CLI takes .md file → outputs JSON with characters    [MET]
  ◐  70%+ accuracy on こころ                               [PARTIAL: 60%, entity resolution needed]
  ○  70%+ accuracy on English novel                        [NOT MET: not tested yet]
  ○  Runs in < 60 seconds                                  [NOT MET: not benchmarked]
  ○  5 writers have seen output                            [NOT MET: not shared yet]
```

## Step 3: Check Each Constraint

For each constraint, determine:

| Status | Meaning |
|--------|---------|
| SATISFIED | Constraint is being followed |
| VIOLATED | **CRITICAL** — flag immediately, must be fixed |
| UNTESTED | Not yet applicable or not verified |

Display constraint status. Violated constraints take priority over all other work.

## Step 4: Surface Learnings

Ask the user **all three questions** (MUST ask all three):

1. **"What surprised you in this session?"**
2. **"What was harder than expected?"**
3. **"What assumption turned out to be wrong?"**

Each answer becomes a candidate for:

| Learning Type | Action |
|---------------|--------|
| Something went wrong that should be prevented | Add a new **Constraint** |
| A choice was made | Add a new **Decision** to the log |
| Something needs more thought | Add a new **Open Question** |
| Informs the next phase | Note for future `learnings.md` |

## Step 5: Update the Prompt-Spec

Apply all changes to the prompt-spec:

- Check off completed criteria (`- [ ]` → `- [x]`)
- Add new Decisions Log entries (with rationale)
- Update Current State (new files, branch, what exists)
- Add any new Constraints discovered
- Add any new Open Questions

## Step 6: Show Progress Summary

```text
Phase 0: Extraction Validation
  Progress: 1/5 criteria met (20%)
  Constraints: 4/4 satisfied
  Open Questions: 1 new, 0 resolved
  Decisions Made: 2 new

  Recommended next action: Run /phase-build targeting criterion 2
```

## Verification

- [ ] Every criterion has a status (MET / NOT MET / PARTIAL)
- [ ] Every constraint has been checked
- [ ] User was asked all three learning questions
- [ ] Prompt-spec was updated with any new decisions, constraints, or state changes
- [ ] Progress summary was displayed
