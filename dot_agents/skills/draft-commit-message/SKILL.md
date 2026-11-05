---
name: draft-commit-message
description:
  Draft a Conventional Commit title and body from staged Git changes when asked
  to prepare a commit message.
---

# Commit Changes

## Review Staged Changes

Inspect `git diff --cached --stat` and `git diff --cached` to understand the
staged changes. Use `git log -10 --pretty=format:%s` to check local title and
scope conventions. Read surrounding files when needed to explain the change
accurately.

Base the message on staged changes. If nothing is staged, report that a message
cannot yet be drafted from the index.

## Write the Message

Use a Conventional Commit title: `<type>(<scope>): <summary>`. Choose a type
that reflects the change and a scope matching the affected tool or platform,
such as `nvim`, `fish`, or `linux`. Use a short, imperative summary.

Separate the title from the body with a blank line. Explain what changed and
why, including platform differences when relevant. Describe only behavior
supported by the diff; do not invent motivation or validation results.

## Output

Return the complete message in a single text code block. Drafting a message does
not authorize staging files, creating a commit, or pushing changes.

Example:

```text
feat(linux): install opencode CLI

Install OpenCode with pacman on Arch Linux.
Keep the existing Homebrew installation on macOS.
```
