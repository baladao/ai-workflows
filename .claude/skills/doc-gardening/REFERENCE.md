# Doc Gardening — Reference

Advanced configuration, detection rules, and safety constraints. The main workflow is in [SKILL.md](SKILL.md).

## Staleness Thresholds

Thresholds have default values but can be adjusted per-project in `.doc-gardening.yml` at repo root.

| Signal | Threshold | Severity |
|--------|-----------|----------|
| Domain code changed >10 commits since doc update | Stale | Warning |
| Domain code changed >30 commits since doc update | Very stale | Critical |
| Domain code changed >500 lines since doc update | Stale | Warning |
| Doc not updated in >90 days (any domain activity) | Potentially stale | Info |
| Active exec-plan not updated in >30 days | Abandoned plan | Warning |
| Completed exec-plan still in `active/` | Misclassified | Warning |

## Domain Mapping

To determine which code "belongs" to a doc:

1. Doc explicitly names directories/files → track those paths
2. Doc in `docs/design-docs/` → domain/package in its title or first heading
3. `ARCHITECTURE.md` → all top-level domain directories
4. `AGENTS.md` → entire repo (reference validity only, not content freshness)
5. `docs/FRONTEND.md` → UI/frontend directories
6. `docs/SECURITY.md` → auth, middleware, boundary-layer code
7. `docs/RELIABILITY.md` → infra, observability, runtime config

## Configuration (`.doc-gardening.yml`)

```yaml
staleness:
  commits_threshold: 10      # flag doc as stale after this many commits in its domain
  lines_threshold: 500       # flag doc as stale after this many lines changed in its domain
  days_threshold: 90         # flag doc as potentially stale after this many days without update
  active_plan_days: 30       # flag an active exec-plan as abandoned after this many days idle

agents_md:
  max_lines: 100             # maximum acceptable line count for AGENTS.md before warning

ignore:
  - docs/generated/**        # skip freshness/link checks for auto-generated docs
  - docs/references/**       # skip checks for external reference material

domains:
  "docs/FRONTEND.md": [src/ui/, src/components/]       # code paths whose changes make this doc stale
  "docs/SECURITY.md": [src/auth/, src/middleware/]     # code paths whose changes make this doc stale
```

## Cross-Reference Validation

**Counts as a reference:**
- Markdown links: `[text](path)` or `[text](path#anchor)`
- Inline code paths containing `/` with known extension
- AGENTS.md and index.md entries

**Does NOT count:**
- URLs (http/https) — external
- Code block contents (fenced) — examples
- Anchor-only links (`#section`)

## Architectural Drift Detection

### Parsing Layer Boundaries

1. Read `ARCHITECTURE.md` for declared layer ordering
2. Look for: arrow notation (`A -> B`), "depends on" statements, tables with allowed imports
3. Extract rules from `docs/DESIGN.md` or `core-beliefs.md`

### Sampling Strategy

1. Identify top-level domain directories
2. Sample up to 20 files per layer per domain
3. Parse import statements (`import`/`require`/`from`)
4. Report violations with file:line references

### Drift Severity

| Type | Severity |
|------|----------|
| UI importing directly from Repo (skipping Service) | Critical |
| Service importing from UI | Critical |
| Types depending on non-external libs | Warning |
| Cross-domain import bypassing Providers | Warning |
| Undocumented utility used by >3 domains | Info |

## Auto-Fix Safety Rules

**NEVER auto-fix:**
- Convention drift (code vs doc disagreement)
- Ambiguous staleness (could be intentionally stable)
- File removal (even orphaned)
- ARCHITECTURE.md content changes
- Exec-plan modifications

**CAN auto-fix:**
- Missing index.md entries
- Broken links with unambiguous rename in git log
- Moving completed exec-plans from `active/` to `completed/`
- Regenerating generated docs via their `<!-- Command: ... -->` header

## Diagnostic: When Agent Struggles

Map failure patterns to missing artifacts:

| Agent Failure | Likely Missing |
|---------------|---------------|
| Inconsistent style choices | `core-beliefs.md` |
| Cross-layer imports | `ARCHITECTURE.md` or enforcement |
| Can't resume prior session work | `docs/exec-plans/` |
| Insecure code patterns | `docs/SECURITY.md` |
| Wrong dependency API calls | `docs/references/` |
