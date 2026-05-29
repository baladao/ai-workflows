---
description: Guide the user to write an execution plan matching the doc-gardening template. Use when user wants to plan complex multi-step work, create a project plan, or structure implementation of a large feature.
allowed-tools: Read, Edit, Write, Bash, AskUserQuestion
---

# Execution Plan Generator

Guide the user through writing an execution plan for: **$ARGUMENTS**

## Process

1. Read the template at `~/.claude/skills/doc-gardening/templates/exec-plan.md`
2. Ask the user to fill in each section interactively, one section at a time
3. Write the completed plan to `docs/exec-plans/active/{slug}.md`
4. Create `docs/exec-plans/active/` and `docs/exec-plans/completed/` if they don't exist

## Section-by-Section Interview

### Required Sections (must have answers)

1. **Goal** — "What does success look like? What user-visible outcome are we shipping? One paragraph."
2. **Context** — "Why now? What triggered this work? Any time pressure, dependencies, or compatibility constraints?"
3. **Steps** — "Break this into sequential steps. For each step: what are the concrete tasks, and how do we know when that step is done? Start with Step 1."
   - For each step, ask:
     - "What are the 2-5 concrete tasks in this step?"
     - "What's the exit criteria — how does an agent know this step is complete?"
   - Keep asking "Is there another step?" until the user says no
   - If more than 6 steps: suggest splitting into multiple plans or grouping steps into phases

### Important Sections (ask, probe)

4. **Risks & Mitigations** — "What could go wrong? For each risk: how likely is it, what's the impact, and what's the mitigation?"
   - If user says "nothing can go wrong" — push back with common risks: dependency issues, scope creep, performance surprises, breaking existing behavior
5. **Completion Criteria** — "Beyond the steps being done, what else must be true? Tests passing? Docs updated? Tech debt logged?"

### Populated Automatically

6. **Decision Log** — Start empty. Add: "No decisions logged yet. Update this section as decisions are made during execution."
7. **Progress Notes** — Start empty. Add: "Plan created YYYY-MM-DD. Execution not yet started."
8. **Tech Debt Introduced** — Start as "None identified yet. Update during and after execution."

## Interview Technique

- If the goal is vague — ask: "If this shipped tomorrow, what would a user notice? What would change?"
- If steps are too large — ask: "Could an agent complete this step in a single PR? If not, break it down further."
- If steps have more than 5 tasks — suggest splitting into two steps
- If there are no exit criteria — ask: "How would a reviewer know this step is complete without asking you?"
- If there are no risks — suggest: "What if the approach turns out to be wrong at step 3? What if a dependency doesn't work as expected? What if it's slower than expected?"

## Writing Guidelines

- Each task should be concrete enough for an agent to execute without clarification
- Exit criteria must be mechanically verifiable (tests pass, linter clean, endpoint responds, etc.)
- Decision log is empty at creation — it fills up during execution
- Plans should be completable in 1-2 weeks. Longer? Split into phases with separate plans.

## After Writing

- Inform the user: "Exec plan written to `docs/exec-plans/active/{slug}.md`"
- Remind: "Update the Progress Notes section at the start of each work session"
- Suggest: "When complete, move to `docs/exec-plans/completed/` and log any tech debt in `tech-debt-tracker.md`"
