---
name: doc-gardening
description: Validates documentation freshness, detects stale docs, broken cross-references, orphaned files, and architectural drift against documented conventions. Produces a quality report and optionally auto-fixes issues or opens fix-up PRs. Use when the user wants to check doc health, find stale documentation, validate AGENTS.md, audit docs/ structure, or run recurring documentation maintenance.
---

# Doc Gardening

Scan repository documentation for staleness, drift, and structural problems. Produce a graded quality report persisted to `docs/DOC_HEALTH.md` and apply targeted fixes.

## When to Run

- Periodically (weekly or per-sprint) as a hygiene pass
- Before major releases to ensure docs reflect current state
- After large refactors that may have invalidated documented paths
- When onboarding — stale docs actively mislead new agents and humans

## Workflow

### Phase 1: Discovery

1. Identify documentation root: `AGENTS.md`, `ARCHITECTURE.md`, `docs/` at repo root
2. Build file inventory of all `.md` files in the doc tree
3. Parse `AGENTS.md` for outbound references (file paths, relative links)
4. Parse index files (`docs/design-docs/index.md`, `docs/product-specs/index.md`) for catalogues

Run `scripts/scan-docs.sh` to automate the structural inventory.

### Phase 2: Freshness Analysis

For each documentation file, check:

- **Broken references**: links pointing to files that no longer exist
- **Staleness**: doc's last-modified vs recent code changes in its domain (git log)
- **AGENTS.md size**: must stay under ~100 lines
- **AGENTS.md accuracy**: every referenced path must resolve
- **Orphaned docs**: files not referenced from their parent index
- **Missing index entries**: files in a directory but absent from its `index.md`

See [REFERENCE.md](REFERENCE.md) for staleness thresholds and domain mapping rules.

### Phase 3: Structural Completeness

Check the project against the expected documentation framework. Only flag items whose absence actively degrades agent effectiveness.

| Artifact | Severity | Remediation |
|----------|----------|-------------|
| `AGENTS.md` | Critical | Create 20-line stub pointing to existing docs |
| `ARCHITECTURE.md` | Critical | Document domain dirs and dependency directions |
| `docs/DESIGN.md` or `core-beliefs.md` | Critical | Draft 5-10 core belief statements |
| `docs/SECURITY.md` | Warning | Boundary rules: input entry, validation points, logging constraints |
| `docs/exec-plans/` structure | Warning | Create `active/`, `completed/`, `tech-debt-tracker.md` |
| `docs/design-docs/index.md` | Warning | Catalogue existing docs with status |
| Layer enforcement (linters/tests) | Warning | Add one structural test for the most critical boundary |
| `docs/QUALITY.md` | Info | Grade each domain/layer A-F |
| `docs/references/` | Info | LLM-friendly docs for top 3 dependencies |
| Local observability | Info | Structured logs queryable by agents |

**Escalation:** 3+ Critical/Warning items missing = "not ready for agent-first development at scale."

### Phase 4: Convention Drift Detection

1. Read `ARCHITECTURE.md` for declared layer boundaries
2. Sample imports in each layer to detect violations
3. Check `docs/DESIGN.md` or `core-beliefs.md` for counter-examples in code
4. Flag as "drift" — human decides whether doc or code needs updating

See [REFERENCE.md](REFERENCE.md) for drift detection sampling strategy and severity levels.

### Phase 5: Quality Report

Produce a graded report following [templates/quality-report.md](templates/quality-report.md) and persist to `docs/DOC_HEALTH.md`.

**On every run:**
1. Overwrite `docs/DOC_HEALTH.md` with fresh findings
2. Preserve Resolved table (append-only) and History table (append new row)
3. Move resolved gaps from Active Action Items to Resolved with date

**Rules:**
- `docs/DOC_HEALTH.md` is referenced from `AGENTS.md` for agent discoverability
- Action items here are the canonical list — not Slack, not tickets
- Never manually edit — the scan owns this file

### Phase 6: Auto-Fix & Auto-Generate (Optional)

When `--fix` is requested or user confirms. See [REFERENCE.md](REFERENCE.md) for safety rules on what can/cannot be auto-fixed.

**Fixes:**
1. Broken links → update or remove (unambiguous renames via git log)
2. Missing index entries → append to relevant index.md
3. AGENTS.md overflow → suggest extractions to sub-docs
4. Orphaned docs → add to parent index or propose deletion

**Auto-managed docs:**
5. Stale generated docs → re-run `<!-- Command: ... -->` from header
6. Missing generated docs → detect sources, create per [templates/generated-doc.md](templates/generated-doc.md)
7. Missing reference docs → scan top imports, create per [templates/reference-doc.md](templates/reference-doc.md)
8. Stale reference docs → flag when lockfile version changes

One commit per category. Never auto-fix convention drift.

## Integration

- **CI**: `scripts/scan-docs.sh` exits non-zero on critical findings
- **Cron**: `/loop 1d /doc-gardening` for daily sweeps
- **PR Gate**: run on PRs touching `docs/`

## Subcommands (Guided Doc Creation)

| Command | Purpose | Output Path |
|---------|---------|-------------|
| `/doc-gardening:product-spec <feature>` | Guided product spec interview | `docs/product-specs/{slug}.md` |
| `/doc-gardening:design-doc <decision>` | Guided design doc interview | `docs/design-docs/{slug}.md` |
| `/doc-gardening:exec-plan <work item>` | Guided execution plan interview | `docs/exec-plans/active/{slug}.md` |

## Auto-Managed Docs (Reference & Generated)

Not user-guided. Created and maintained automatically during Phase 6:

- **Reference docs** (`docs/references/`): auto-generated when agents make repeated mistakes with a dependency or during initial setup for top-used packages. Template: [templates/reference-doc.md](templates/reference-doc.md).
- **Generated docs** (`docs/generated/`): auto-detected from schema files, route defs, env configs. Regenerated when source changes. Template: [templates/generated-doc.md](templates/generated-doc.md).

## Templates

- [templates/quality-report.md](templates/quality-report.md) — DOC_HEALTH.md format and grading rubric
- [templates/product-spec.md](templates/product-spec.md) — User-facing features (guided)
- [templates/design-doc.md](templates/design-doc.md) — Technical decisions (guided)
- [templates/exec-plan.md](templates/exec-plan.md) — Implementation plans (guided)
- [templates/reference-doc.md](templates/reference-doc.md) — Dependency docs (auto-managed)
- [templates/generated-doc.md](templates/generated-doc.md) — Code-derived docs (auto-managed)
