---
description: Guide the user to write a product spec matching the doc-gardening template. Use when user wants to create a new product spec, feature spec, or document a user-facing feature.
allowed-tools: Read, Edit, Write, Bash, AskUserQuestion
---

# Product Spec Generator

Guide the user through writing a product spec for: **$ARGUMENTS**

## Process

1. Read the template at `~/.claude/skills/doc-gardening/templates/product-spec.md`
2. Ask the user to fill in each section interactively, one section at a time
3. Write the completed spec to `docs/product-specs/{slug}.md`
4. Update `docs/product-specs/index.md` if it exists

## Section-by-Section Interview

Ask the user for each section below. Do NOT skip sections — if the user says "I don't know" for optional ones, mark them as "TBD" in the doc. For required sections, push back and help them think through it.

### Required Sections (must have answers before writing)

1. **Summary** — "In one sentence, what does this feature do for the user?"
2. **Problem** — "Who experiences this pain? How often? What do they do today instead?"
3. **User Stories** — "Describe the primary flow as: As a [persona], I want to [action] so that [outcome]. Any secondary flows?"
4. **Acceptance Criteria** — "What are the mechanical checks? Write as: Given X, when Y, then Z. Include at least one error case and one edge case."
5. **Scope** — "What is explicitly IN scope? What is explicitly OUT of scope?"

### Important Sections (ask, accept brief answers)

6. **UX Behavior** — "Walk me through the happy path step by step. What error states should we handle?"
7. **Success Metrics** — "How will we know this is working? What numbers would prove success?"
8. **Dependencies** — "Does this depend on any other feature, service, or component being ready first?"

### Optional Sections (ask, accept "TBD")

9. **Open Questions** — "Any unresolved product questions?"
10. **References** — "Any mockups, design docs, or user research to link?"

## Writing Guidelines

- Acceptance criteria must be testable by an agent (no vague language)
- "The feature should be fast" → ask: "What latency target? Under what conditions?"
- "Users can manage X" → ask: "What specific actions? What's the given/when/then?"
- Keep the spec focused on WHAT and FOR WHOM — not HOW (that's a design doc)

## After Writing

- Inform the user: "Spec written to `docs/product-specs/{slug}.md`"
- If `docs/product-specs/index.md` exists, add an entry
- Suggest next steps: "Consider creating a design doc for the technical approach, then an exec plan for implementation"
