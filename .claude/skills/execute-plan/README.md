# Execute Plan

Implements a previously planned ticket using TDD in a git worktree. Reads the plan from `.tasks/to-do/<TICKET_ID>.md`, writes failing tests first, then iterates implementation until all checks pass. Opens a draft PR on completion.

## Usage

```
/execute-plan <TICKET_ID>
```

See [SKILL.md](SKILL.md) for the full step sequence.
