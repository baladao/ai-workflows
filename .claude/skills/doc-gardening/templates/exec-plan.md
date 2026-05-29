# Execution Plan Template

For complex, multi-step work spanning multiple PRs or days. Not needed for single-PR changes.

## Template

```markdown
# Exec Plan: {TITLE}

**Status:** Draft | In Progress | Blocked | Completed | Abandoned
**Created:** YYYY-MM-DD
**Last Updated:** YYYY-MM-DD
**Owner:** {who is driving this}
**Target:** YYYY-MM-DD (or "no deadline")

## Goal

One paragraph. What does success look like? What user-visible outcome?

## Context

Why now? What triggered this? Link to product spec or design doc.
Constraints: time pressure, dependencies, compatibility.

## Approach

### Step 1: {short name}
- [ ] {concrete task}
- [ ] {concrete task}
- **Exit criteria:** {how we know this step is done}

### Step 2: {short name}
- [ ] {concrete task}
- [ ] {concrete task}
- **Exit criteria:** {how we know this step is done}

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| {what could go wrong} | Low/Med/High | Low/Med/High | {how} |

## Decision Log

| Date | Decision | Rationale |
|------|----------|-----------|
| YYYY-MM-DD | {decided} | {why, including what was rejected} |

## Progress Notes

### YYYY-MM-DD
- {what happened}
- {blockers}
- {next action}

## Tech Debt Introduced

- {shortcuts taken needing future cleanup}

## Completion Criteria

- [ ] All steps done
- [ ] Tests passing
- [ ] Documentation updated
- [ ] Tech debt logged in tech-debt-tracker.md
```

## When to Create

- Work spanning 2-3+ PRs
- Coordination across domains
- Refactors touching multiple layers
- Context loss between sessions would be costly

## Lifecycle

1. **Draft** → scoped, may be incomplete
2. **In Progress** → progress notes updated each session
3. **Blocked** → document blocker and owner
4. **Completed** → move from `active/` to `completed/`
5. **Abandoned** → document why, move to `completed/`

## Tips

- Update BEFORE each session (re-read, mark progress, adjust)
- Decision log is the most valuable section long-term
- Tasks must be concrete enough for an agent to execute without clarification
- More than 5 tasks per step → split into multiple steps
