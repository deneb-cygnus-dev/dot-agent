#!/usr/bin/env bash
# install.sh — Seed this repo with upstream everything-claude-code content.
#
# Run this script once to populate the repo with upstream agents, commands,
# contexts, hooks, rules, and skills. Re-run it whenever you want to pull in
# upstream changes.
#
# After running, review the changes and commit them so projects that use this
# repo as a submodule automatically pick up the new content.
#
# Usage:
#   ./install.sh          — Install / update upstream content
#   ./install.sh --help   — Show this message
#
# Local skills preserved (never overwritten by upstream):
#   backend-patterns-go, coding-standards, draft-pr, generate-impl-doc,
#   make-business-plan, security-review-go, tdd-workflow

set -euo pipefail

UPSTREAM_REPO="https://github.com/deneb-cygnus-dev/everything-claude-code.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Helpers ──────────────────────────────────────────────────────────────────

info()    { echo "  [info] $*"; }
success() { echo "  [ok]   $*"; }
warn()    { echo "  [warn] $*" >&2; }
error()   { echo "  [err]  $*" >&2; exit 1; }

usage() {
  sed -n '2,/^$/p' "$0" | sed 's/^# \?//'
  exit 0
}

# ── Argument parsing ──────────────────────────────────────────────────────────

for arg in "$@"; do
  case "$arg" in
    --help|-h) usage ;;
    *) warn "Unknown argument: $arg (ignoring)" ;;
  esac
done

# ── Preflight ─────────────────────────────────────────────────────────────────

echo ""
echo "dot-agent install — syncing from upstream"
echo "=========================================="
echo ""

command -v git &>/dev/null || error "git is required but not found in PATH"

info "Repo root:     $SCRIPT_DIR"
info "Upstream:      $UPSTREAM_REPO"
echo ""

# ── Clone upstream ────────────────────────────────────────────────────────────

UPSTREAM_DIR="$(mktemp -d)"
trap 'rm -rf "$UPSTREAM_DIR"' EXIT

info "Cloning upstream (shallow)..."
git clone --depth 1 --quiet "$UPSTREAM_REPO" "$UPSTREAM_DIR" \
  || error "Failed to clone: $UPSTREAM_REPO"
success "Upstream cloned"
echo ""

# ── Copy component: agents ────────────────────────────────────────────────────

if [[ -d "$UPSTREAM_DIR/agents" ]]; then
  mkdir -p "$SCRIPT_DIR/agents"
  cp -r "$UPSTREAM_DIR/agents/." "$SCRIPT_DIR/agents/"
  success "agents/ synced"
fi

# ── Copy component: commands ──────────────────────────────────────────────────

if [[ -d "$UPSTREAM_DIR/commands" ]]; then
  mkdir -p "$SCRIPT_DIR/commands"
  cp -r "$UPSTREAM_DIR/commands/." "$SCRIPT_DIR/commands/"
  success "commands/ synced"
fi

# ── Copy component: contexts ──────────────────────────────────────────────────

if [[ -d "$UPSTREAM_DIR/contexts" ]]; then
  mkdir -p "$SCRIPT_DIR/contexts"
  cp -r "$UPSTREAM_DIR/contexts/." "$SCRIPT_DIR/contexts/"
  success "contexts/ synced"
fi

# ── Copy component: hooks ─────────────────────────────────────────────────────

if [[ -d "$UPSTREAM_DIR/hooks" ]]; then
  mkdir -p "$SCRIPT_DIR/hooks"
  cp -r "$UPSTREAM_DIR/hooks/." "$SCRIPT_DIR/hooks/"

  # Patch ${CLAUDE_PLUGIN_ROOT}/ → .claude/ in hooks.json.
  #
  # ${CLAUDE_PLUGIN_ROOT} is only set by Claude Code for plugin installs under
  # ~/.claude/plugins/. When this repo is used as a project-level submodule
  # (symlinked as .claude/), the variable is never defined and every
  # script-based hook silently fails.
  #
  # The .claude/ symlink is always present in the project root, so hook
  # commands that run from the project root can reach .claude/scripts/…
  # or .claude/skills/… through it — no plugin install required.
  if [[ -f "$SCRIPT_DIR/hooks/hooks.json" ]]; then
    sed -i.bak 's|\${CLAUDE_PLUGIN_ROOT}/|.claude/|g' "$SCRIPT_DIR/hooks/hooks.json"
    rm -f "$SCRIPT_DIR/hooks/hooks.json.bak"
    success "hooks/ synced  (hooks.json: \${CLAUDE_PLUGIN_ROOT} → .claude/)"
  else
    success "hooks/ synced"
  fi
fi

# ── Copy component: scripts ───────────────────────────────────────────────────

# scripts/ contains the Node.js hook implementations referenced by hooks.json.
# install.sh previously skipped this directory, leaving hooks broken.
if [[ -d "$UPSTREAM_DIR/scripts" ]]; then
  mkdir -p "$SCRIPT_DIR/scripts"
  cp -r "$UPSTREAM_DIR/scripts/." "$SCRIPT_DIR/scripts/"
  success "scripts/ synced"
fi

# ── Copy component: rules ─────────────────────────────────────────────────────

if [[ -d "$UPSTREAM_DIR/rules" ]]; then
  mkdir -p "$SCRIPT_DIR/rules"
  cp -r "$UPSTREAM_DIR/rules/." "$SCRIPT_DIR/rules/"
  success "rules/ synced"
fi

# ── Copy component: skills (skip locally-managed ones) ───────────────────────

echo ""
info "Syncing skills (local skills take priority)..."

mkdir -p "$SCRIPT_DIR/skills"

# Skills that are managed locally — the upstream version is NOT installed.
# - coding-standards   : multi-language (TypeScript + Go + Python) — superset of upstream
# - tdd-workflow       : multi-language (TypeScript + Go + Python + Flutter) — superset of upstream
# - backend-patterns-go: Go-specific — renamed to avoid conflict with upstream TypeScript version
# - security-review-go : Go-specific — renamed to avoid conflict with upstream TypeScript version
# - draft-pr           : local-only (not in upstream)
# - generate-impl-doc  : local-only (not in upstream)
# - make-business-plan : local-only (not in upstream)
LOCAL_SKILLS=(
  "coding-standards"
  "tdd-workflow"
  "backend-patterns-go"
  "security-review-go"
  "draft-pr"
  "generate-impl-doc"
  "make-business-plan"
)

for skill_dir in "$UPSTREAM_DIR/skills"/*/; do
  skill_name="$(basename "$skill_dir")"

  # Check whether this skill is locally managed
  is_local=false
  for local_skill in "${LOCAL_SKILLS[@]}"; do
    if [[ "$skill_name" == "$local_skill" ]]; then
      is_local=true
      break
    fi
  done

  if [[ "$is_local" == true ]]; then
    warn "skill $skill_name — skipped (local version preserved)"
    continue
  fi

  # Check if there's an existing local directory for this skill
  if [[ -d "$SCRIPT_DIR/skills/$skill_name" ]]; then
    # Overwrite with upstream (non-local skills are always synced from upstream)
    rm -rf "$SCRIPT_DIR/skills/$skill_name"
  fi

  cp -r "$skill_dir" "$SCRIPT_DIR/skills/$skill_name"
  success "skill $skill_name"
done

echo ""

# ── Summary ───────────────────────────────────────────────────────────────────

echo "Sync complete!"
echo ""
echo "Content now in repo:"
[[ -d "$SCRIPT_DIR/agents"   ]] && echo "  agents:   $(find "$SCRIPT_DIR/agents"   -maxdepth 1 -name "*.md" | wc -l | tr -d ' ') agents"
[[ -d "$SCRIPT_DIR/skills"   ]] && echo "  skills:   $(find "$SCRIPT_DIR/skills"   -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ') skills"
[[ -d "$SCRIPT_DIR/commands" ]] && echo "  commands: $(find "$SCRIPT_DIR/commands" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ') commands"
[[ -d "$SCRIPT_DIR/rules"    ]] && echo "  rules:    $(find "$SCRIPT_DIR/rules"    -name "*.md" | wc -l | tr -d ' ') rule files"
[[ -d "$SCRIPT_DIR/hooks"    ]] && echo "  hooks:    present"
[[ -d "$SCRIPT_DIR/scripts"  ]] && echo "  scripts:  $(find "$SCRIPT_DIR/scripts" -name "*.js" | wc -l | tr -d ' ') scripts"
[[ -d "$SCRIPT_DIR/contexts" ]] && echo "  contexts: $(find "$SCRIPT_DIR/contexts" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ') contexts"
echo ""
echo "Next step: review changes and commit."
echo "  git add -A && git status"
echo ""
