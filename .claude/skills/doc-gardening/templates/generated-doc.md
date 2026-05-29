# Generated Doc Template

Documentation produced automatically from code, schemas, or configuration. Never manually edited — regenerated on source change.

## Template

```markdown
<!-- GENERATED FILE — DO NOT EDIT MANUALLY -->
<!-- Source: {path to source of truth} -->
<!-- Generated: YYYY-MM-DD HH:MM:SS -->
<!-- Command: {command that regenerates this file} -->

# {TITLE}

{Generated content — tables, schemas, API surfaces, etc.}

---

_Auto-generated from `{source path}`. Regenerate: `{command}`_
```

## Example: Database Schema

```markdown
<!-- GENERATED FILE — DO NOT EDIT MANUALLY -->
<!-- Source: prisma/schema.prisma -->
<!-- Generated: 2026-05-29 14:30:00 -->
<!-- Command: npm run generate:db-docs -->

# Database Schema

## Tables

### users
| Column | Type | Nullable | Default |
|--------|------|----------|---------|
| id | uuid | No | gen_random_uuid() |
| email | varchar(255) | No | — |
| created_at | timestamptz | No | now() |

## Relationships
- users.id -> posts.author_id (one-to-many)
```

## When to Create

- Database schema → regenerate on every migration
- API endpoints → regenerate when routes change
- Environment variables → regenerate when config schema changes
- Type exports → regenerate on package changes

## Rules

1. Always include the 4-line generation header (Source, Generated, Command)
2. Include the regeneration command — agents use it for auto-fix
3. Source path must be accurate — staleness detection relies on it
4. Timestamp enables comparing against source file mtime

## Integration with Doc Gardening

The scan checks generated docs by:
1. Parsing `<!-- Source: ... -->` header
2. Comparing source mtime against `<!-- Generated: ... -->` timestamp
3. Flagging as stale if source is newer
4. Auto-fix: re-run `<!-- Command: ... -->`
