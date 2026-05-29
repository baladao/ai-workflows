# Plan Ticket

- THIS SKILL MUST NOT WRITE ANY CODE
- THIS SKILL MUST OUTPUT A .tasks/to-do/$ARGUMENTS[0].md FILE

## Plan for $ARGUMENTS[0]

0. Make sure you are up to date with main remote code, and an existing $ARGUMENTS[0] git worktree; create a new worktree if necessary
0.1. Continue writting the claude task with name $ARGUMENTS[0], create the task file under .tasks/to-do/ if necessary
0.2. DO NOT WRITE ANY CODE WHILE THIS SKILL IN IN PROGRESS
1. Using atlassian plugin to Jira, read the ticket $ARGUMENTS[0] description and comments in full
1.1. In the ticket description look for any figma links, if there is a link present use figma plugin to fetch de designs data
2. Create an implementation plan following this file @tasks/TEMPLATE.md as template with this added context:
2.1. Study 2-3 similar existing components in the codebase using grep and read to understand patterns (types, component file structure, SCSS module conventions, hook patterns, fetch conventions and import/exports rules). Ask for file examples if you are unable to find them
2.2. Evaluate the figma design and any relevant comments
2.3. Avoid creating components or behavior that already exist somewhere else in the codebase or its dependencies. Ask for files with similar functionality if you are unable to find them
2.4. Determine self contained incremental implementation steps
2.5. Determine Acceptance Criteria explicetely
2.5.1. Each functional acceptance criteria requirement should have a test to represent it
2.6. List Types, Test and Components that should be created or edited with their respective reasoning for each
3. Ask me to review the plan, do not implement anything
