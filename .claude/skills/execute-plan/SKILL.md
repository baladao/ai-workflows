# Execute Plan

## Execution Plan for $ARGUMENTS[0]

0. Make sure you are on main and up to date with remote code. use the named $ARGUMENTS[0] git worktree or create it if necessary
0.1. Read the plan created in the task file $ARGUMENTS[0] under the .tasks/to-do/$ARGUMENTS[0].md file
1. Start by writing tests for each defined step and each of the acceptance criteria
1.1. After writting the tests, run them to prove they FAIL
2. Rules for each major file implemented:
2.1. Run typecheck and lint, fix all issues found
2.2. Run the tests for changed files and see them PASS to prove implementation is actually complete
2.3. Iterate code changes on any failures up to 3 times per issue.
2.4. For remaining failures, provide context for and ask for my review
2.5. If no test failures are present, commit the work in progress
3. Start the code implementation following each step until you reach the acceptance criteriaf
4. Once all tests are passing, linting and typeckeck is successfully built.
4.1. Create a DRAFT Pull Request describing the changes done.
4.1.1. The title should be `feat|fix|chore($ARGUMENTS[0]): <brief description>` 
4.1.2. Add the tag: `preview` to the PR
4.1.3. Assign ownership of the PR to myself
4.2. The PR description should be concise and include:
4.2.1. The original ticket link
4.2.2. URL examples for the preview environment (https://booking-ui-<branch-name>.preview.pathinternal/)
4.2.3. URL examples for production environment (https://www.rula.com/)
