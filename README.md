# dot-agent

> **Version:** v1.0.0
> **Last updated:** 2026-03-03
> **Author:** Hao Jin

Personal Claude Code dotfiles repository for Hao Jin.

This repo is the single source of truth for Claude Code configuration across all personal projects. Other repositories include it as a **git submodule** so they automatically inherit all agents, skills, commands, rules, hooks, and contexts without any per-project setup.

---

## What this repo provides

| Component | Count | Description |
|---|---|---|
| `agents/` | 14 | Specialized subagents (planner, architect, code reviewer, Go reviewer, security reviewer, etc.) |
| `commands/` | 35 | Slash commands (`/plan`, `/tdd`, `/code-review`, `/go-build`, `/security-scan`, etc.) |
| `contexts/` | 3 | Dynamic system prompt injections for dev, research, and review modes |
| `hooks/` | — | Event-triggered automations across the session lifecycle |
| `rules/` | 30 files | Always-follow coding guidelines organized by language (common, TypeScript, Python, Go, Swift) |
| `skills/` | 61 | Workflow and domain knowledge skills (see breakdown below) |

---

## Upstream origin

Most content in this repo is sourced from **[everything-claude-code](https://github.com/affaan-m/everything-claude-code)** by [@affaan-m](https://github.com/affaan-m) — a comprehensive Claude Code plugin covering agents, skills, commands, rules, hooks, and contexts.

The `install.sh` script syncs from a **personal fork** of that project ([deneb-cygnus-dev/everything-claude-code](https://github.com/deneb-cygnus-dev/everything-claude-code)), which acts as a proxy between the true upstream and this repo. Using a fork rather than the original upstream allows changes to be staged and reviewed before they land here.

```text
affaan-m/everything-claude-code   ← true upstream
         ↓  (fork)
deneb-cygnus-dev/everything-claude-code   ← proxy fork
         ↓  (install.sh)
dot-agent   ← this repo
```

---

## Skills breakdown

Skills are the core reusable workflows. This repo has two categories:

### Upstream skills (synced from the proxy fork)

These are managed by `./install.sh` and overwritten on each sync. Examples:

- Language patterns: `backend-patterns`, `frontend-patterns`, `golang-patterns`, `python-patterns`, `swift-concurrency-6-2`, `cpp-coding-standards`, `java-coding-standards`
- Framework patterns: `django-patterns`, `springboot-patterns`, `swiftui-patterns`, `docker-patterns`
- Testing: `e2e-testing`, `golang-testing`, `python-testing`, `django-tdd`, `springboot-tdd`
- Security: `security-review`, `security-scan`, `django-security`, `springboot-security`
- LLM / AI: `cost-aware-llm-pipeline`, `foundation-models-on-device`, `eval-harness`, `iterative-retrieval`, `continuous-learning-v2`
- Business / writing: `market-research`, `investor-materials`, `investor-outreach`, `article-writing`
- And more: `database-migrations`, `postgres-patterns`, `deployment-patterns`, `search-first`, `verification-loop`, …

### Local skills (managed in this repo, never overwritten by upstream sync)

| Skill | Description |
|---|---|
| `backend-patterns-go` | Go-specific backend patterns (chi router, singleflight, connection pooling, graceful shutdown). Coexists with upstream's TypeScript `backend-patterns`. |
| `coding-standards` | Multi-language coding standards (TypeScript, Go, Python) with per-language reference files. Superset of upstream's TypeScript-only version. |
| `draft-pr` | Drafts a PR title and description from the branch diff; creates via `gh pr create` or saves locally with `--local`. |
| `generate-impl-doc` | Generates 5W1H implementation documentation for a feature branch and saves it to `docs/implementations/`. |
| `make-business-plan` | Guided business plan generator: runs a three-round questionnaire then produces a versioned markdown plan with all 18 standard sections. |
| `security-review-go` | Go-specific security patterns (govulncheck, gorilla/csrf, bluemonday, parameterized SQL). Coexists with upstream's TypeScript `security-review`. |
| `tdd-workflow` | Multi-language TDD workflow (Go, Python, TypeScript, Flutter/Dart) with per-language reference files. Superset of upstream's TypeScript-only version. |

---

## How to update this repo

Run `./install.sh` whenever you want to pull in new upstream agents, skills, commands, rules, hooks, or contexts.

```bash
./install.sh
```

The script:

1. Clones the proxy fork (shallow) to a temporary directory
2. Copies `agents/`, `commands/`, `contexts/`, `hooks/`, and `rules/` into this repo, replacing the previous upstream content
3. Copies upstream skills into `skills/`, **skipping** the local skills listed above
4. Prints a summary of what was installed

After running, review the diff and commit:

```bash
git add -A
git status          # review what changed
git commit -m "chore: sync upstream everything-claude-code"
```

New upstream skills and agents are picked up automatically on every sync. If you add a new local skill that shares a name with an upstream skill, add it to the `LOCAL_SKILLS` array in `install.sh` to protect it from being overwritten.

---

## Migration workflow (for future major syncs)

Use this process when the upstream has changed substantially — new skill categories, renamed components, or when you need to merge a new local skill that conflicts with something upstream. Routine syncs only need `./install.sh`; this workflow is for the harder cases.

### Step 1 — Inventory local vs upstream skills

Produce a set-diff between what you have and what upstream offers:

```bash
# Clone upstream to a temp dir
git clone --depth 1 https://github.com/deneb-cygnus-dev/everything-claude-code /tmp/ecc

# Skills only in upstream (candidates to import)
comm -23 <(ls /tmp/ecc/skills | sort) <(ls skills | sort)

# Skills only in local (must be preserved)
comm -13 <(ls /tmp/ecc/skills | sort) <(ls skills | sort)

# Skills present in both (potential conflicts — require deep review)
comm -12 <(ls /tmp/ecc/skills | sort) <(ls skills | sort)
```

### Step 2 — Deep-compare conflicting skills

For every skill that appears in both repos, compare content — not just names. A name collision does not mean the content is the same:

- Read both `SKILL.md` files side by side
- Check the scope: is the local version language-specific (Go, Python) while the upstream is TypeScript? → rename local, keep both
- Check coverage: does the local version contain content absent from upstream? → merge or keep local
- Is the local version a true duplicate? → delete local, let upstream version in

Decision matrix used in the v1.0.0 migration:

| Situation | Action |
|---|---|
| Local = language-specific (e.g., Go), upstream = TypeScript | Rename local with language suffix (`backend-patterns-go`) |
| Local = multi-language superset of upstream's single-language version | Keep local; update its TypeScript section to match upstream quality |
| Local = exact or near-exact duplicate of upstream | Delete local; upstream version installs automatically |
| Local = unique workflow not present in upstream at all | Keep local; add to `LOCAL_SKILLS` in `install.sh` |

### Step 3 — Rename conflicting local skills

When keeping a language-specific local skill alongside an upstream skill of the same base name, rename with a language suffix at the end:

```bash
mv skills/backend-patterns skills/backend-patterns-go
# Update the name: field in skills/backend-patterns-go/SKILL.md to match
```

Update `LOCAL_SKILLS` in `install.sh` to use the new name.

### Step 4 — Update local skills that are supersets of upstream

If a local skill is broader than the upstream version (e.g., multi-language vs TypeScript-only), backfill any content the upstream has that the local version is missing. Focus on the overlapping language section (usually TypeScript):

- Missing code examples or patterns
- Missing testing strategies or mock patterns
- Missing performance or security subsections

Do not copy wholesale — integrate selectively so the local multi-language structure is preserved.

### Step 5 — Run the install script

With conflicts resolved and `LOCAL_SKILLS` updated, run the sync:

```bash
./install.sh
```

Verify the output summary shows the expected skip/install counts.

### Step 6 — Post-install quality checks

After the sync, run these checks in order:

**6a. Markdownlint**

```bash
mise exec -- markdownlint "**/*.md" --config .markdownlint.json
```

Common violations introduced by upstream content:

- `MD040` — bare code fences with no language tag. Fix with a Python heuristic script or manually. Language hints: `bash` for shell commands, `json`/`yaml` for config, `typescript`/`go`/`python` for code, `text` for prose in a code block.
- `MD041` — file does not start with a top-level heading. If the file uses YAML frontmatter with a `name:` field, the `.markdownlint.json` config already handles this; otherwise add a `#` heading before any table or prose.
- `MD033` — inline HTML. Common cause: unescaped `<hash>` or `<variable>` placeholders in text. Wrap them in backticks.

Auto-fix spacing issues first, then handle remaining violations manually:

```bash
mise exec -- markdownlint "**/*.md" --config .markdownlint.json --fix
mise exec -- markdownlint "**/*.md" --config .markdownlint.json   # should be clean
```

**6b. Union-set verification**

Confirm no upstream skill was accidentally dropped:

```bash
comm -23 <(ls /tmp/ecc/skills | sort) <(ls skills | sort)
# Should print nothing (all upstream skills are present locally)
```

Confirm local-only skills are still present:

```bash
comm -13 <(ls /tmp/ecc/skills | sort) <(ls skills | sort)
# Should list exactly the LOCAL_SKILLS entries
```

**6c. Naming consistency**

Verify each skill directory's `name:` frontmatter field matches the directory name:

```bash
for d in skills/*/; do
  name=$(basename "$d")
  declared=$(grep "^name:" "$d/SKILL.md" 2>/dev/null | head -1 | awk '{print $2}')
  [ "$name" != "$declared" ] && echo "MISMATCH: $name vs $declared"
done
```

**6d. Structural compliance for agents and commands**

Agents must have valid frontmatter (`name:`, `description:`, `model:`, `tools:`). Model field accepts short aliases: `opus`, `sonnet`, `haiku`.

Commands are valid with or without frontmatter — if a `description:` field is present it overrides the first-paragraph fallback, but it is not required.

Contexts require no frontmatter. Hooks require a valid `hooks/hooks.json`. Rules use optional `paths:` frontmatter for language scoping.

### Step 7 — Commit

```bash
git add -A
git status    # review
git commit -m "chore: sync upstream everything-claude-code vX.Y.Z"
```

---

## Using this repo as a submodule

```bash
# Add to a project
git submodule add https://github.com/haojin-dev/dot-agent .dotfiles

# Update to latest
git submodule update --remote .dotfiles
```

All content is committed directly to this repo, so submodule users get everything without any network access or additional installation steps beyond `git submodule update --init`.
