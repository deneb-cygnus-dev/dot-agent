# Usage Examples

## Example 1: Feature branch with explicit path

**Input:**

```text
/make-worktree --name feature/add-database-migrations --path ~/workspace/worktrees/myrepo main
```

**Result:**

- Branch: `feature/add-database-migrations`
- Directory name: `add-database-migrations` (feature/ stripped)
- Full path: `~/workspace/worktrees/myrepo/add-database-migrations`
- Commands run:

  ```bash
  git worktree add -b feature/add-database-migrations ~/workspace/worktrees/myrepo/add-database-migrations main
  cd ~/workspace/worktrees/myrepo/add-database-migrations
  git submodule update --init
  mise trust  # if mise config exists
  ```

---

## Example 2: Fix branch with explicit path

**Input:**

```text
/make-worktree --name fix/git-handler-null-check --path ~/workspace/worktrees/myrepo
```

**Result:**

- Branch: `fix/git-handler-null-check`
- Directory name: `fix-git-handler-null-check` (slash replaced with hyphen)
- Full path: `~/workspace/worktrees/myrepo/fix-git-handler-null-check`

---

## Example 3: Feature branch without path (auto-resolve)

Assume current repo is `dot-agent` and `~/workspace/worktrees/dot-agent/` exists.

**Input:**

```text
/make-worktree --name feature/add-blablabla
```

**Result:**

- Repo detected: `dot-agent`
- Path resolved: `~/workspace/worktrees/dot-agent` (default location exists)
- Full path: `~/workspace/worktrees/dot-agent/add-blablabla`

---

## Example 4: Chore branch

**Input:**

```text
/make-worktree --name chore/update-dependencies --path ~/workspace/worktrees/myrepo
```

**Result:**

- Directory name: `chore-update-dependencies`
- Full path: `~/workspace/worktrees/myrepo/chore-update-dependencies`

---

## Example 5: Path auto-resolve with nested worktrees directory

Assume current repo is `backend-api` and `~/workspace/projects/worktrees/backend-api/` exists (but `~/workspace/worktrees/backend-api/` does not).

**Input:**

```text
/make-worktree --name feature/user-auth
```

**Result:**

- Default `~/workspace/worktrees/backend-api` not found
- Search finds `~/workspace/projects/worktrees/backend-api`
- Full path: `~/workspace/projects/worktrees/backend-api/user-auth`
