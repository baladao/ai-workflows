# Review the work changes for a pull request

## PR Review Skill

1. Read the diff with `git diff main...HEAD` and the current worktree for $ARGUMENTS[0] task
2. Check for type errors: `npx tsc --noEmit`
3. Run linter
4. Review for: unused imports, naming consistency, missing test coverage
5. Write Cypress tests (NEVER Jest) for any new components
6. Evaluate security issues (exposed secrets, SQL injection, etc.)
7. Check for performance concerns
8. Check for breaking changes
9. Summarize findings as a checklist
9.1. Issues found (if any)
9.1.1. Iterate fixes for each issue a maximum of 3 times
9.1.2. Document issues found and how they were fixed
9.2. Risk level LOW / MEDIUM / HIGH explaining why
9.3. Suggestions for future improvement
10. Pull in reviews from the remote PR and fix them if available
10.1. You can reply with a brief description for the fix, 5~10 words if possible, and resolve that comment.
11. Make sure PR description match changes in the worktree
