---
name: phase-status
description: Use anytime to see progress across all phases. Shows acceptance criteria completion, open questions, and decisions for each phase. Read-only — does not modify any files.
model: claude-sonnet-4-6
---

# Phase Status — Progress Dashboard

## When to Activate

- User says "where am I" or "show progress" or "what's the status"
- User invokes `/phase-status`
- User needs orientation before deciding what to do next

**This skill is read-only. It MUST NOT modify any files.**

## Step 1: Scan for All Phase Directories

Look for `phases/*/prompt-spec.md`. Sort by directory name (alphabetical, which naturally sorts numbered phases).

If no phases exist, display:

```text
No phases found. Run /phase-kick to start your first phase.
```

## Step 2: Parse Each Prompt-Spec

For each phase, extract:

| Data Point | How to Extract |
|------------|---------------|
| Phase name | Directory name and `# Phase N:` heading |
| Total criteria | Count all `- [ ]` and `- [x]` lines in Acceptance Criteria |
| Met criteria | Count `- [x]` lines |
| Open questions | Count rows in Open Questions with Status = Open |
| Decisions | Count rows in Decisions Log |
| Status | Derive from rules below |

### Phase Status Rules

| Status | Condition |
|--------|-----------|
| `COMPLETE` | All criteria met AND `learnings.md` exists in phase directory |
| `ACTIVE` | Some criteria met, or phase in progress |
| `NOT STARTED` | Prompt-spec exists but no criteria met |
| `BLOCKED` | Has open questions with past-due dates |

## Step 3: Display Dashboard

```text
╔═══════════════════════════════════════════════════════╗
║  Phase-Driven Development Status                      ║
║  Product: {product name}                              ║
╠═══════════════════════════════════════════════════════╣
║                                                       ║
║  Phase 0: Extraction Validation    [COMPLETE] ✓       ║
║    Criteria: 5/5 met                                  ║
║    Decisions: 4 | Duration: 5 days                    ║
║                                                       ║
║  Phase 1: MVP Web App              [ACTIVE]           ║
║    Criteria: 2/7 met                                  ║
║    ✓ User auth implemented                            ║
║    ✓ Manuscript upload working                        ║
║    ○ Graph visualization                              ║
║    ○ Consistency alerts                               ║
║    ○ JP + EN verified                                 ║
║    ○ Timeline view                                    ║
║    ○ Deployed to Fly.io                               ║
║    Open Questions: 1 | Decisions: 6                   ║
║                                                       ║
║  Phase 2: Retention & Growth       [NOT STARTED]      ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
```

For the ACTIVE phase, list each criterion with ✓ or ○.

## Step 4: Highlight Blockers

If any blockers exist, display them prominently:

```text
⚠ Blockers:
  - Open Question #3 was due 2026-03-10 (2 days overdue)
  - Constraint "MUST NOT exceed $5 API cost" status: UNTESTED
```

Check for:

- Past-due open questions
- Violated constraints (from last review)
- Stale prompt-spec (Current State doesn't match actual files)

## Verification

- [ ] All phases are displayed
- [ ] Criteria counts are accurate
- [ ] No files were modified (read-only)
