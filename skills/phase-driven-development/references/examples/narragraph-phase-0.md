# Phase 0: Extraction Validation

> STATUS: COMPLETE — 2026-03-16
> Started: 2026-03-11
> Business Plan: business/narra-graph/business-plan.md
> Previous Phase Learnings: N/A — first phase

---

## Intent

Validate that Claude API can parse a 100k-word novel manuscript into structured data — characters, relationships, and timeline events — with 70%+ accuracy in Japanese and English. This is the kill-or-proceed gate for NarraGraph. If extraction quality is insufficient, the product concept is invalidated. Scope: CLI only. No UI, no database, no web server.

---

## Current State

- **Branch:** `phase-0/extraction-validation`
- **Existing files:**
  - `cmd/extract/main.go` — CLI entry point
  - `internal/extraction/pipeline.go` — chapter splitting + Claude API calls
  - `internal/extraction/entities.go` — entity resolution (coreference)
  - `internal/extraction/types.go` — JSON output structures
- **Runnable artifact:** `go run cmd/extract/main.go input.md > output.json`
- **Notes:** Entity resolution pass added after Day 2 review showed 30% duplicate characters

---

## Constraints

- MUST use Claude API structured output (JSON mode)
- MUST handle UTF-8 CJK (Japanese novel is the primary test case)
- MUST NOT build any UI — CLI only for this phase
- MUST NOT add a database — JSON file output only
- MUST stay under $5 total API cost for all validation runs
- SHOULD process chapter-by-chapter (whole-novel exceeds context window)

---

## Acceptance Criteria

- [x] CLI takes .md file path, outputs JSON with characters array (name, first_appearance, description)
- [x] 70%+ character extraction accuracy on 夏目漱石 こころ (JP) — achieved 78%
- [x] 70%+ character extraction accuracy on Pride and Prejudice (EN) — achieved 85%
- [x] Character relationships captured as edges (character_a, character_b, relationship_type)
- [x] Runs in < 60 seconds for 100k-word novel — achieved 42 seconds
- NOT MET (deferred): Timeline events extraction — deferred to Phase 1, see Decisions Log

---

## Open Questions

| # | Question | Owner | Due | Status |
|---|----------|-------|-----|--------|
| 1 | SurrealDB vs Neo4j for Phase 1? | Founder | Phase 1 kick | Open (deferred) |

---

## Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-03-11 | Process chapter-by-chapter, not whole novel | Whole novel exceeds context window. Chapter-by-chapter also allows progress tracking. |
| 2026-03-11 | Entity resolution as separate pass | Initial extraction creates duplicates ("Elena" vs "she" vs "the detective"). Two-pass approach: extract, then merge. |
| 2026-03-13 | Claude API over GPT-4 for extraction | Better Japanese structured output in testing. 15% higher accuracy on こころ. |
| 2026-03-14 | Defer timeline extraction to Phase 1 | 4/5 test writers said character graph alone is valuable. Timeline extraction needs significant work (non-linear narrative handling). Doesn't block Phase 0 validation. |
| 2026-03-15 | PROCEED to Phase 1 | Extraction quality validated at 78% (JP) and 85% (EN). 4/5 writers rated output as useful. Core assumption confirmed. |
