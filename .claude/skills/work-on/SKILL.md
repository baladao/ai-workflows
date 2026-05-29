# Work start to finish on a given Ticket

## Start to Finish $ARGUMENTS[0] 

0. $ARGUMENTS[0] will be passed to subsequent skill executions
1. run `/plan-ticket $ARGUMENTS[0]`
2. ask the user to review the plan from the previews step output path
3. run `/execute-plan $ARGUMENTS[0]`
4. run `/design-review $ARGUMENTS[0]`
5. ask the user to go to the PR link from the previews step and test the changes on preview environment
