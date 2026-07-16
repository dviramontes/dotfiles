---
name: commit-and-push
description: run all checks, commit and push code to upstream branch
---

## Commit Workflow
0. Run `mix format`
1. Run `mix chech.all` — fix any warnings
2. Run `mix test.unit` — fix any failures
3. Check the code against `./docs/STYLE_GUIDE.md`
4. Grep for unused imports/aliases in changed files and remove them
5. Stage changes with `git add -A`
6. Write a conventional commit message referencing the Linear ticket if applicable
7. Push to current branch
