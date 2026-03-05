# Path Resolution Algorithm

When `--path` is not provided, resolve the worktree base directory using this fallback chain. Stop at the first match.

**Important:** The containing directory may be named either `worktrees` or `worktree`. Both must be checked at every step.

## Step 1: Check default locations

```bash
test -d ~/workspace/worktrees/<repo-name> || test -d ~/workspace/worktree/<repo-name>
```

If either exists, use it as the base. If both exist, prefer `worktrees`.

## Step 2: Search under ~/workspace

If neither default exists, search for an existing directory that contains the repo name under a `worktrees` or `worktree` parent:

```bash
find ~/workspace -maxdepth 4 -type d -name "<repo-name>" \( -path "*/worktrees/*" -o -path "*/worktree/*" \) 2>/dev/null
```

If exactly one result is found, use it as the base.

If multiple results are found, list them and ask the user to pick one or provide `--path` explicitly.

## Step 3: No match found

If no existing directory matches, fall back to creating the default:

```bash
mkdir -p ~/workspace/worktrees/<repo-name>
```

Use `~/workspace/worktrees/<repo-name>` as the base.

---

## Summary

| Priority | Condition | Base path |
|----------|-----------|-----------|
| 1 | `~/workspace/worktrees/<repo-name>` exists | `~/workspace/worktrees/<repo-name>` |
| 1 | `~/workspace/worktree/<repo-name>` exists | `~/workspace/worktree/<repo-name>` |
| 2 | Single match under `~/workspace/**/(worktrees\|worktree)/<repo-name>` | The matched path |
| 3 | Multiple matches | Ask user to choose |
| 4 | No match | Create `~/workspace/worktrees/<repo-name>` |
