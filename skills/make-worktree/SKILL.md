---
name: make-worktree
description: Create a git worktree with correct branch naming conventions and directory placement. Use when the user wants to start a new feature or fix branch using git worktrees. Handles branch creation, path resolution, submodule initialization, and mise trust automatically.
argument-hint: "--name <branch-name> [--path <worktree-base-path>]"
allowed-tools: Bash(git *), Bash(mise *), Bash(go *), Bash(npm *), Bash(ls *), Bash(find *), Bash(mkdir *), Bash(test *), Bash(cat *), Bash(basename *), Bash(dirname *)
model: claude-sonnet-4-6
---

# Git Worktree Creator

## Argument Parsing

- `--name` (required): The full branch name. Must follow `<type>/<kebab-case-description>` format.
  - Valid types: `feature`, `fix`, `chore`, `refactor`, `docs`, `test`, `perf`
  - Example: `feature/add-database-migrations`, `fix/git-handler-null-check`
- `--path` (optional): The base worktree directory for this repo. Example: `~/workspace/worktrees/myrepo`

If `--name` is omitted, ask the user for the branch name before proceeding.

## Step 1: Validate Branch Name

The branch name (`--name` value) MUST match: `<type>/<kebab-case-words>`

- Type must be one of: `feature`, `fix`, `chore`, `refactor`, `docs`, `test`, `perf`
- Description must be kebab-case (lowercase words separated by hyphens)
- If invalid, report the error and stop. Do NOT guess or auto-correct.

## Step 2: Determine Repo Name

```bash
basename "$(git rev-parse --show-toplevel)"
```

This gives the repo name used for directory naming.

## Step 3: Resolve Worktree Path

The worktree directory name is derived from the branch name:

| Branch type | Directory name |
|-------------|---------------|
| `feature/*` | Just the description part (strip `feature/`) |
| All others  | `<type>-<description>` (replace `/` with `-`) |

Examples:

- `feature/add-blablabla` -> directory name: `add-blablabla`
- `fix/git-handler-null` -> directory name: `fix-git-handler-null`

**Path resolution order:**

1. If `--path` is provided, check whether the path exists. If it does NOT exist, report to the user that the path does not exist and ask how they want to proceed (create it, provide a different path, or abort). Do NOT silently create it or continue.
2. If `--path` is provided and valid, use it directly as the base: `<--path>/<dir-name>`
3. If `--path` is NOT provided, read [references/path-resolution.md](./references/path-resolution.md) and follow the fallback algorithm.

## Step 4: Check Branch Uniqueness

Before creating the worktree, verify the branch does not already exist:

```bash
git branch --list <branch-name>
```

If the branch already exists, stop and report: "Error: branch `<branch-name>` already exists." Do NOT proceed.

## Step 5: Create the Worktree

Always branch from the default branch (`main`):

```bash
git worktree add -b <branch-name> <resolved-full-path> main
```

## Step 6: Post-Creation Initialization

After the worktree is created, `cd` into the worktree directory and run:

### 6a. Initialize submodules

```bash
cd <resolved-full-path> && git submodule update --init
```

### 6b. Trust mise configuration

Check if a mise config file exists, then trust it:

```bash
ls mise.toml .mise.toml mise.*.toml .mise.*.toml 2>/dev/null
```

If any file is found:

```bash
mise trust
```

### 6c. Report completion

Print a summary:

```text
Worktree created:
  Branch: <branch-name>
  Path:   <resolved-full-path>
  Submodules: initialized
  Mise: trusted (or: no mise config found)
```

## References

| Reference | When to read |
|-----------|-------------|
| [path-resolution.md](./references/path-resolution.md) | `--path` is NOT provided; need to discover the worktree base directory |
| [examples.md](./references/examples.md) | Need to see concrete usage examples for various argument combinations |
