# Doc Gardening

Scans repository documentation for staleness, broken references, orphaned files, and architectural drift. Produces a graded quality report at `docs/DOC_HEALTH.md` and optionally auto-fixes safe issues.

## Usage

```
/doc-gardening              # Full scan
/doc-gardening --fix        # Scan + auto-fix
/doc-gardening <file>       # Targeted scan
```

## Subcommands

- `/doc-gardening:product-spec <feature>` — Guided product spec
- `/doc-gardening:design-doc <decision>` — Guided design doc
- `/doc-gardening:exec-plan <work item>` — Guided execution plan

## References

- [SKILL.md](SKILL.md) — Full workflow specification
- [REFERENCE.md](REFERENCE.md) — Thresholds, config, and safety rules
- [EXAMPLES.md](EXAMPLES.md) — Sample reports and invocation patterns
