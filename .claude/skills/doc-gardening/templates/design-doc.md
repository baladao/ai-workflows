# Design Doc Template

Captures technical decisions that affect architecture, introduce patterns, or have long-term consequences. The goal: future agents and humans don't re-litigate settled decisions.

## Template

```markdown
# Design Doc: {TITLE}

**Status:** Draft | Under Review | Accepted | Superseded by {link}
**Created:** YYYY-MM-DD
**Last Verified:** YYYY-MM-DD
**Author:** {who proposed}

## Problem Statement

What specific problem does this solve? One paragraph, no solution language.
Who is affected, how often, cost of inaction.

## Constraints

- {hard requirement limiting the solution space}
- {performance budget, compatibility, security boundary}
- {timeline, team size, existing dependencies}

## Solution

### Overview

One paragraph: chosen approach at high level.

### Design

- Data flow or sequence descriptions
- API contracts / interface shapes
- State transitions if applicable
- Integration with existing architecture layers

### Alternatives Considered

#### Alternative A: {name}
{1-2 paragraphs}
**Rejected because:** {specific reason}

#### Alternative B: {name}
{1-2 paragraphs}
**Rejected because:** {specific reason}

## Impact

- **Architecture:** layers/domains affected, new dependencies, graph changes
- **Security:** new attack surface, data classification, auth changes
- **Performance:** latency/throughput changes, resource consumption

## Verification

- [ ] {test proving correctness}
- [ ] {benchmark proving performance budget met}
- [ ] {security check if applicable}

## References

- {product spec, exec plan, external prior art}
```

## When to Create

- New architectural pattern or domain/layer
- Changing dependency directions
- Choosing between viable technical approaches
- Any "why is it this way?" question worth answering for future readers

## When NOT Needed

- Bug fixes (commit message suffices)
- Features following existing patterns perfectly
- Dependency updates with no architectural impact

## Verification Cadence

Re-verify when:
- Code described changes significantly (>10 commits)
- New design doc in the same domain is proposed

Mark as "Superseded" (not deleted) when replaced — reasoning history has value.
