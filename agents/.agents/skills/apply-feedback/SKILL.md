---
name: apply-feedback
description: Retrieve feedback from GitHub pull requests and apply suggested changes locally. Use when users want to fetch PR review comments, apply code review feedback, or address reviewer suggestions without replying to external services.
---

# Apply PR Feedback Locally

Retrieve PR review comments from GitHub and apply the suggested changes to local files. Analyzes feedback and makes appropriate code changes without interacting with external services.

## Core Workflow

1. Get PR info: `gh pr view --json number,url`
2. Extract owner/repo from the URL
3. Fetch comments from GitHub API
4. Analyze each comment for actionable feedback
5. Apply changes to local files
6. Summarize what was done

## Fetching Comments

```bash
# PR-level comments (general discussion)
gh api /repos/{owner}/{repo}/issues/{number}/comments

# Code review comments (inline on specific lines)
gh api /repos/{owner}/{repo}/pulls/{number}/comments
```

## Review Comment Fields

- `body` - The comment text with the feedback
- `path` - File path being commented on
- `line` - Line number in the file
- `diff_hunk` - Code context around the comment
- `in_reply_to_id` - Parent comment ID (for threaded replies)

## Applying Feedback

For each actionable comment:

1. Read the file using the `path` field
2. Locate the code using `line` and `diff_hunk`
3. Analyze the `body` for what change is requested
4. Apply the change locally
5. Skip non-actionable comments (questions, acknowledgments, discussions)

## Guidelines

- Never reply to comments on GitHub—only apply changes locally
- Never create or update Linear tickets
- Never interact with AppSignal exceptions
- Never push or commit automatically—let the user decide
- Ask for clarification if a comment is ambiguous
- Present options with a recommendation if multiple approaches exist
- Inform the user if you cannot apply a suggestion and explain why
- Group related changes when multiple comments affect the same file
- Preserve code style and formatting conventions of the existing codebase

## Confirmation

After processing all comments, report:
- Each comment and action taken (applied, skipped, needs clarification)
- Files modified
- Suggested next steps (run tests, linting, etc.)
