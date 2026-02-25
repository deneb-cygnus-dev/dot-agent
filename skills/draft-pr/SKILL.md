---
name: draft-pr
description: Draft a PR title and description for the current branch and open it directly with `gh pr create`. Reads the branch diff against main, produces a conventional-commits title and a structured description (Summary / Changes / Test Plan), then creates the PR immediately. Pass --local as the first argument to save to pr-draft.md instead. Optionally pass a file path as the second argument to override the default output file.
argument-hint: "[--local [file-path]]"
allowed-tools: Bash(gh *)
model: claude-haiku-4-5
---

# PR Draft Generator

## Argument Dispatch

- First argument (`$0`): `$0`
- Second argument (`$1`): `$1`

Evaluate `$0` exactly to select the workflow reference to follow:

| `$0` value | Workflow reference |
|------------|--------------------|
| `--local` | [references/local.md](./references/local.md) — save to `$1` if provided, otherwise `pr-draft.md` |
| *(anything else, including empty)* | [references/gh.md](./references/gh.md) — create the PR via `gh pr create` |

Do not infer mode from free-form text. Only the exact string `--local` as the first argument activates the local workflow.

---

## Prerequisites

1. **Check current branch**: Must be on a feature/fix branch, not `main` or `master`
2. **Check for changes**: There must be commits that differ from `main`
3. **Check gh auth** (default mode only): `gh auth status` must show an authenticated account

---

## Step 1: Gather Branch Information

```bash
git branch --show-current
git diff main --stat
git diff main
git log main..HEAD --oneline
git log main..HEAD --pretty=format:"%h - %s (%an, %ad)" --date=short
```

---

## Step 2: Compose the PR Title

Write a single line in [Conventional Commits](https://www.conventionalcommits.org/) format:

```text
<type>(<scope>): <short imperative description>
```

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

**Rules:** scope is optional; description must be lowercase, imperative, no trailing period, under 72 characters total.

---

## Step 3: Compose the PR Description

```markdown
## Summary

- {High-level accomplishment — **bold** key terms, `inline-code` file paths}

## Changes

### {Sub-section: Implementation / Documentation / etc.}

| File | Description |
|------|-------------|
| `path/to/file` | What was added, changed, or removed and why |

## Test Plan

- [x] {Step already run and passed}
- [ ] {Deferred step — reason in parentheses}

## Next Steps

- {Immediate follow-up out of scope for this PR}

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

**Summary:** feature-level bullets; omit file paths here — those belong in Changes.
**Changes:** group into sub-sections when the PR spans multiple concerns; skip sub-sections for single-concern changes.
**Test Plan:** `[x]` = already executed; `[ ]` = deferred/manual with a reason.
**Next Steps:** omit section entirely if there are no direct follow-ups.
**Optional sections:** add domain-specific tables (pool settings, migration lists, spec refs) only when they give the reviewer concrete context.

---

## Step 4: Deliver

Read the workflow reference selected in the Argument Dispatch table above and follow it to deliver the output.

---

## Step 5: Validation

- [ ] Branch is not `main` or `master`
- [ ] Title follows conventional commits format and is under 72 characters
- [ ] "Summary" bullets are feature-level, not file-level
- [ ] "Changes" table rows reference actual files or components
- [ ] "Test Plan" has at least one entry; all `[x]` items were actually run
- [ ] No sensitive information (secrets, credentials, tokens) in the description
