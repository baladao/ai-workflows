---
description: Guide the user to write a design doc matching the doc-gardening template. Use when user wants to document a technical decision, architectural choice, or new pattern.
allowed-tools: Read, Edit, Write, Bash, AskUserQuestion
---

# Design Doc Generator

Guide the user through writing a design doc for: **$ARGUMENTS**

## Process

1. Read the template at `~/.claude/skills/doc-gardening/templates/design-doc.md`
2. Ask the user to fill in each section interactively, one section at a time
3. Write the completed doc to `docs/design-docs/{slug}.md`
4. Update `docs/design-docs/index.md` if it exists

## Section-by-Section Interview

### Required Sections (must have answers)

1. **Problem Statement** — "What specific problem does this solve? Who is affected, how often, and what's the cost of inaction? Keep solution language out of this section."
2. **Constraints** — "What hard requirements limit the solution space? Think: performance budgets, compatibility needs, security boundaries, timeline, team size."
3. **Solution Overview** — "Describe your chosen approach in one paragraph at a high level."
4. **Solution Design** — "Now go deeper: data flow, API contracts, state transitions, integration with existing architecture layers. Which layers does this touch?"
5. **Alternatives Considered** — "What other approaches did you consider? For each: briefly describe it, then explain specifically why you rejected it. Need at least one alternative."

### Important Sections (ask, probe if vague)

6. **Architecture Impact** — "Which layers/domains are affected? Any new dependencies? Does this change the dependency graph?"
7. **Security Impact** — "Any new attack surface? Data classification of new flows? Auth changes?"
8. **Performance Impact** — "Expected latency/throughput changes? New resource consumption?"
9. **Verification** — "How do we confirm this works? What tests, benchmarks, or checks prove correctness?"

### Optional Sections (ask, accept "TBD")

10. **Open Questions** — "Any unresolved technical questions? Who owns answering them?"
11. **References** — "Any product specs, exec plans, or external prior art to link?"

## Interview Technique

- If the user says "I haven't considered alternatives" — help them brainstorm at least one. Common alternatives: do nothing, use an existing library, different architectural layer, different data model.
- If constraints are vague — probe: "Is there a latency budget? A data size limit? A security boundary this crosses?"
- If the solution is unclear — ask: "If I were an agent implementing this, what's the first file I'd touch? What's the interface I'd build?"
- If impact sections get "none" — challenge gently: "Are you sure there's no performance impact? What about the hot path?"

## Writing Guidelines

- The "Alternatives Considered" section is the most valuable long-term — it prevents re-litigation
- "Rejected because it felt wrong" is never acceptable — push for specifics
- Design docs are for future readers who ask "why?" — optimize for that reader
- Cross-reference the product spec that motivated this decision if one exists

## After Writing

- Inform the user: "Design doc written to `docs/design-docs/{slug}.md`"
- If `docs/design-docs/index.md` exists, add an entry with status "Draft"
- Suggest: "Mark as 'Under Review' when shared with the team. Update to 'Accepted' once validated."
