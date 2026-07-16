---
name: contribute
description: Commits changes, pushes the current branch, and opens a pull request. Use when asked to contribute work, open a PR, or finish changes for review.
---

# Contribute Workflow

Use this skill to take completed local changes from verification through an opened pull request.

## Workflow

1. Inspect the current state:
   - Run `git status --short --branch`.
   - Confirm the branch name is appropriate for the work or create/switch to the requested branch.
   - Review changed files with `git diff` and, if needed, `git diff --staged`.

2. Run project checks:
   - Prefer the repository's documented full check command when available.
   - For this Elixir/Phoenix project pattern, run:
     - `mix format`
     - `mix check.all`
   - If the project has faster/required targeted checks documented, run those first, then broaden when appropriate.
   - Fix any failures caused by the current changes.

3. Do a final cleanup pass:
   - Check changed files for unused imports, aliases, variables, or obvious formatting issues.
   - Re-run formatting/checks after fixes when needed.

4. Stage and commit:
   - Run `git add -A`.
   - Write a concise conventional commit message.
   - Reference the Linear ticket in the commit subject or body when applicable, e.g. `PLAT-385`.
   - Use `git commit` with real line breaks for multi-line messages, not literal `\n` escapes.

5. Push:
   - Push the current branch to its upstream.
   - If no upstream exists, push with `git push -u origin HEAD`.

6. Open the pull request:
   - Prefer GitHub CLI when available:
     - `gh pr create --fill`
   - If `--fill` would omit important context, provide an explicit title/body:
     - Title: concise summary, preferably including the ticket key.
     - Body: include what changed, verification run, and related Linear issue.
   - If `gh` is unavailable or not authenticated, report the pushed branch and provide a ready-to-paste PR title/body instead of pretending the PR was opened.
   - PR title format: `<branch-name>: <concise-summary>`
     - example: `OPS-2591: Create proposal heading`
7. Final response:
   - Include the commit hash, branch name, PR URL, and checks run.
   - Mention any checks that could not be run or any PR-opening blocker.

## Safety

- Do not discard or revert user/other-agent changes unless explicitly asked.
- Ask before force-pushing, rewriting history, deleting branches, or deleting untracked data.
- Do not push if checks fail unless the user explicitly asks to push failing work.
