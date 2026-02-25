# Workflow: Save to Local File

Determine the output path:

| `$1` value | Output path |
|------------|-------------|
| Provided | `$1` (as given) |
| Empty | `pr-draft.md` in the project root |

Write the file using the template below, then print the title and full description to the terminal.

## File Template

```markdown
# PR Draft — {branch-name}

> Generated: {YYYY-MM-DD}

## Title

{conventional commits title}

---

## Description

{full description body}
```

## Output

Print the title and full description to the terminal so the user can copy-paste without opening the file.

---

## Example — `docs: add frontend development guide`

Invoked as `/draft-pr --local` → saves to `pr-draft.md`.
Invoked as `/draft-pr --local docs/pr-draft.md` → saves to `docs/pr-draft.md`.

**File content:**

```markdown
# PR Draft — feature/add-front-end-dev-guide

> Generated: 2026-02-25

## Title

docs: add frontend development guide and fix Node.js version across docs

---

## Description

## Summary

- Introduces `docs/DEVELOPMENT-FRONT.md`, a 17-phase frontend implementation guide covering project setup, type system, API service layer, Zustand state, CodeMirror 6, markdown-it preview, file tree virtualization, performance, accessibility, testing (Vitest + Playwright), and deployment
- Upgrades the Node.js build image from `node:20-alpine` (Maintenance LTS, EOL April 2026) to `node:22-alpine` (Active LTS) across all documentation
- Bumps **PRD to v1.4** and propagates the updated version reference across all SRS and development guides

## Changes

| File | Description |
|------|-------------|
| `docs/DEVELOPMENT-FRONT.md` | New file: 17-phase frontend build guide |
| `docs/markdown-manager-prd.md` | Bumped to v1.4; replaced `node:20-alpine` → `node:22-alpine`; added v1.4 entry to Document History |
| `docs/backend-srs.md` | Corrected PRD version reference from v1.3 → v1.4 |
| `docs/frontend-srs.md` | Corrected PRD version reference from v1.3 → v1.4 |
| `docs/DEVELOPMENT.md` | Corrected PRD version reference from v1.3 → v1.4 |

## Test Plan

- [x] All internal PRD/SRS cross-references point to v1.4
- [x] No broken markdown links in `docs/DEVELOPMENT-FRONT.md`
- [ ] Frontend phase 1 scaffolding verified against guide (deferred — implementation not started)

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```
