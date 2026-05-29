# Reference Doc Template

LLM-friendly documentation of external dependencies. Only what agents need to use the dependency correctly — not a full reference.

## Template

```markdown
# Reference: {DEPENDENCY NAME}

**Version:** {pinned version}
**Source:** {official docs URL}
**Why:** {one sentence — what it solves for us}

## Quick Start

\`\`\`typescript
// Most common usage pattern in this codebase
{example}
\`\`\`

## API Surface (What We Use)

### {Function/Method}

\`\`\`typescript
{signature}
\`\`\`

- **Purpose:** {what it does}
- **Our Usage:** {where we call it, any wrapper}
- **Throws:** {error conditions}

## Configuration

\`\`\`typescript
// Location: {config path}
{our actual configuration}
\`\`\`

## Gotchas

- {footgun — what looks right but breaks}
- {subtle behavior difference from similar libs}
- {what it can't do that you might assume}

## Patterns We Follow

- {convention that differs from official examples}
- {required wrapper or helper to use}

## Patterns We Avoid

- {anti-pattern agents must not use}
- {deprecated API still in docs/training data}
```

## When to Create

- Agent made 2+ mistakes with this dependency's API
- Large API surface but we only use a small slice
- Behavior differs from common training data (newer version, unusual config)
- Internal wrapper exists that agents should prefer

## Naming

`{name}-llms.txt` or `{name}-reference.md` — the `-llms.txt` suffix signals AI-optimized format.

## What NOT to Include

- Full API docs (link to official instead)
- Methods/classes we don't use
- Tutorials or concept explanations
- Version history

## Freshness Triggers

- Dependency version changes in lockfile
- New parts of the API start being used
- A wrapper is added that changes preferred usage
