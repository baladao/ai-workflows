# Product Spec Template

Describes a user-facing feature from the product perspective. The "what" and "for whom" — not the "how" (that lives in design docs and exec plans).

## Template

```markdown
# Product Spec: {FEATURE NAME}

**Status:** Draft | Accepted | In Development | Shipped | Deprecated
**Created:** YYYY-MM-DD
**Product Owner:** {who owns the feature}

## Summary

One sentence: what this feature does for the user.

## Problem

- Who experiences this? (persona or segment)
- How often? (daily, weekly, edge case)
- What do they do today? (workaround, competitor, nothing)
- Cost of not solving it? (churn, support tickets, lost revenue)

## User Stories

> As a {persona}, I want to {action} so that {outcome}.

## Acceptance Criteria

Testable statements an agent can validate:

- [ ] Given X, when Y, then Z
- [ ] Edge case: given X, when Y, then Z
- [ ] Error case: given X, when Y, then Z
- [ ] Performance: action completes within N ms

## Scope

**In:** {what this includes}
**Out:** {what this explicitly does NOT include}

## UX Behavior

**Happy path:** {step-by-step}

**Error states:**
| Trigger | User Sees | Recovery |
|---------|-----------|----------|
| {failure} | {UI state} | {action} |

**Edge cases:** empty state, overflow, concurrent access, offline

## Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| {what} | {number} | {how} |

## Dependencies

- {features, services, or components needed first}

## References

- {design doc, exec plan, mockups, user research}
```

## When to Create

- Any user-facing feature before implementation
- Changes to existing user flows
- Features needing product/engineering/design alignment

## Acceptance Criteria Quality

- **Testable** — agent can write a test for it
- **Specific** — no ambiguity about "done"
- **Observable** — visible in UI, API response, or logs
- **Bounded** — states what's NOT included

Bad: "The feature should be fast"
Good: "Search results render within 200ms for queries up to 100 characters"
