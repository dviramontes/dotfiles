---
name: notion-progress
description: Write a summary of the current conversation progress to Notion. Use when users want to document work completed, create a handoff summary for another agent, or log changes made to the codebase.
---

# Write Progress to Notion

Document the progress of the current conversation to Notion. Creates a page summarizing changes made, files modified, and decisions taken during the session. Serves as a handoff document for another agent to continue the work.

## Core Workflow

1. Get the git branch name: `git branch --show-current`
2. Gather session information from the conversation
3. Format the summary as structured markdown
4. Create or update the Notion page using the Notion MCP

## Default Database

**Database ID:** `1a86470adf8c80528eaaed5cd0afb502`

Use `notion_query_database` to check if a page for this branch exists. Update existing pages rather than creating duplicates.

## Information to Gather

- **Task Description** - What was the user trying to accomplish?
- **Files Modified** - All files created, edited, or deleted
- **Key Changes** - Substantive changes made to each file
- **Decisions Made** - Architectural or implementation decisions with rationale
- **Open Items** - Unfinished work, blockers, or next steps
- **Commands Run** - Significant commands executed (tests, builds, migrations)

## Page Format

```markdown
# {branch-name}

## Task
{Brief description of the goal}

## Changes Made
- `path/to/file1.ext` - {what changed}
- `path/to/file2.ext` - {what changed}

## Decisions
- {Decision 1 and rationale}

## Open Items
- [ ] {Unfinished task 1}

## Notes for Next Agent
{Context that helps another agent continue this work}
```

## Guidelines

- Use the exact git branch name as the page title
- Write concise, actionable summaries
- Focus on information that helps another agent continue the work
- Include specific file paths and line numbers where relevant
- Document failed attempts or dead ends (saves time for the next agent)
- Never include sensitive information (API keys, passwords, credentials)
- Only document what actually happened—no assumptions

## Confirmation

After creating/updating the page, report the page title and URL to the user.
