# Quality Report Template

Format for `docs/DOC_HEALTH.md` — the persistent, in-repo documentation health record.

## Template

```markdown
# Documentation Health

<!-- Maintained by /doc-gardening — do not edit manually -->
<!-- Last scan: YYYY-MM-DD -->

**Overall Grade:** {A-F} (score: {0-100})
**Agent-Ready:** {Yes/No}

## Active Action Items

| # | Severity | Finding | Since |
|---|----------|---------|-------|
| 1 | {Critical/Warning/Info} | {what is missing + specific remediation} | YYYY-MM-DD |

## Findings

### Critical (blocks agent effectiveness)
- [ ] {finding with file:line if applicable}

### Warning (degrades agent context quality)
- [ ] {finding with file:line if applicable}

### Info (housekeeping)
- [ ] {finding}

## Grades by Area

| Area | Grade | Issues | Notes |
|------|-------|--------|-------|
| AGENTS.md | {A-F} | {count} | {one-line note} |
| Architecture | {A-F} | {count} | {note} |
| Design Docs | {A-F} | {count} | {note} |
| Product Specs | {A-F} | {count} | {note} |
| Exec Plans | {A-F} | {count} | {note} |
| Structural Completeness | {A-F} | {count} | {note} |

## Resolved

| Artifact | Resolved | Was Severity |
|----------|----------|--------------|
| {artifact} | YYYY-MM-DD | {Critical/Warning} |

## History

| Date | Grade | Score | Gaps | Findings |
|------|-------|-------|------|----------|
| YYYY-MM-DD | {A-F} | {0-100} | {count} | {count} |
```

## Grading Rubric

```
score = 100 - (critical * 20) - (warning * 5) - (info * 1)

A: score >= 90    B: score >= 75    C: score >= 60    D: score >= 40    F: score < 40
```

Agent-Ready = "No" when 3+ structural gaps at Critical/Warning level.

## Section Behavior

| Section | On Each Scan |
|---------|-------------|
| Active Action Items | Regenerated — only current gaps appear |
| Findings | Regenerated — fresh from latest analysis |
| Grades by Area | Regenerated |
| Resolved | Append-only — items move here when artifact is created |
| History | Append-only — one row per scan date (deduplicates same-day) |

## Rules

- Each Action Item includes a **specific remediation** — never just "X is missing"
- "Since" date is preserved across scans for still-open items
- Findings use checkboxes (`- [ ]`) with `file:line` where applicable
- Never manually edit this file — create the missing artifact and the next scan updates it
- Referenced from `AGENTS.md` so agents can check doc health on demand
