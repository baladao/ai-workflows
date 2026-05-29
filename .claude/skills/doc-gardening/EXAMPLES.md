# Doc Gardening — Examples

## Sample Report (Grade C)

```markdown
# Documentation Health

<!-- Maintained by /doc-gardening — do not edit manually -->
<!-- Last scan: 2026-05-29 -->

**Overall Grade:** C (score: 62)
**Agent-Ready:** Yes

## Active Action Items

| # | Severity | Finding | Since |
|---|----------|---------|-------|
| 1 | Warning | Create `docs/SECURITY.md` — boundary rules, input validation, logging | 2026-05-20 |
| 2 | Warning | Add structural test for UI->Repo boundary | 2026-05-20 |

## Findings

### Critical
- [ ] `AGENTS.md:47` references `docs/API.md` which does not exist
- [ ] `docs/design-docs/caching-strategy.md` stale — 34 commits in `src/cache/` since last update

### Warning
- [ ] `AGENTS.md` is 137 lines (target: <=100)
- [ ] `docs/design-docs/auth-flow.md` not listed in index.md
- [ ] `src/ui/Settings.tsx` imports `src/repo/userRepo.ts` — layer violation

### Info
- [ ] `docs/design-docs/old-search-impl.md` orphaned (not in index)
- [ ] `docs/generated/db-schema.md` is 3 days behind latest migration

## Grades by Area
| Area | Grade | Issues | Notes |
|------|-------|--------|-------|
| AGENTS.md | C | 2 | Over 100 lines + broken ref |
| Architecture | B | 1 | 1 layer violation |
| Design Docs | D | 3 | Stale + orphaned + unindexed |
| Structural Completeness | B | 2 | 2 warning-level gaps |

## Resolved
| Artifact | Resolved | Was Severity |
|----------|----------|--------------|
| AGENTS.md | 2026-05-15 | Critical |
| ARCHITECTURE.md | 2026-05-15 | Critical |

## History
| Date | Grade | Score | Gaps | Findings |
|------|-------|-------|------|----------|
| 2026-05-29 | C | 62 | 2 | 7 |
| 2026-05-22 | D | 40 | 4 | 9 |
| 2026-05-15 | F | 20 | 6 | 11 |
```

## Invocation Patterns

```
/doc-gardening              # Full scan, persist to DOC_HEALTH.md
/doc-gardening --fix        # Scan + apply safe auto-fixes
/doc-gardening AGENTS.md    # Targeted scan of AGENTS.md only
/loop 1d /doc-gardening     # Daily automated sweep
```

## Useful Git Commands for Analysis

```bash
# When was a doc last modified?
git log -1 --format="%ai" -- docs/DESIGN.md

# Commits in domain since doc was last updated
DOC_DATE=$(git log -1 --format="%ai" -- docs/FRONTEND.md)
git log --since="$DOC_DATE" --oneline -- src/ui/ | wc -l

# Detect file renames (for fixing broken links)
git log --diff-filter=R --summary -- docs/ | grep "rename"
```

## AGENTS.md Trim Example

**Before (137 lines):** Full architecture, conventions, testing, deployment inline.

**After (78 lines):** One-paragraph overview, key constraint, then pointers:
```markdown
## Where to Find Things
- Design decisions: docs/design-docs/index.md
- Product specs: docs/product-specs/index.md
- Active work: docs/exec-plans/active/
- Quality grades: docs/QUALITY.md
- Security model: docs/SECURITY.md
- Doc health: docs/DOC_HEALTH.md
```
