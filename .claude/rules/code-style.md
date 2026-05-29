# TypeScript Strict Mode

**Always** use TypeScript strict mode in any project.

## Required tsconfig settings

- `"strict": true`
- `"noImplicitAny": true`
- `"strictNullChecks": true`

## When writing code

- Always build Server Side Rendering compliant components, only require client code for behavior related code
- Always favor CSS composition, animations or show/hide patterns before JS rules
- Never use `any` — use `unknown` if type is truly unknown
- Never provide explicit return types for functions
- Handle null/undefined cases explicitly
- Write tests for the changes to ensure this is covered and we dont have a regression unless is intended

## Verification

Before completing any task involving TypeScript:

- Always format and lint the code after changes
- Fix all type errors
- Do not suppress with `@ts-ignore` unless absolutely necessary (and document why)
