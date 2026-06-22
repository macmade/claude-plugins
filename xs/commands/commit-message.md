---
description: Generate a Conventional Commits message for the current changes (staged, unstaged, and untracked), without committing.
---

Generate a commit message describing the current changes in the repository. Only produce the message — never stage, commit, or push anything. Follow these steps exactly and do not skip the interactive prompt.

## 1. Choose the change scope (multiple selection)

- Use `AskUserQuestion` with `multiSelect: true` so the user can pick one scope or any combination of scopes:
  - **Staged** — changes staged for commit (the index).
  - **Unstaged** — tracked files with unstaged modifications in the working tree.
  - **Untracked** — files not yet tracked by git.
- Take the **union** of the selected scopes. Only describe changes from the selected scopes.

## 2. Collect the changes

- Work from the repository root (`git rev-parse --show-toplevel`).
- For each selected scope, gather the corresponding changes, excluding submodules and gitignored files by construction:
  - **Staged** → `git diff --cached`
  - **Unstaged** → `git diff`
  - **Untracked** → list with `git ls-files -o --exclude-standard`, then read each file's contents (untracked files do not appear in `git diff`).
- If the selected scopes contain no changes, stop and tell the user there is nothing to describe.

## 3. Understand the changes

- Read the diffs and the untracked files, and make sure you actually understand what changed and why before writing anything. Do not assume — read the surrounding source code if a change is unclear.
- Consider all collected changes together as a single coherent set, regardless of which scopes they came from.

## 4. Write the commit message

- Follow Conventional Commits. Look at the previous commits (`git log`) for the types, scopes, and style actually used in this repository, and match them.
- Use a concise, imperative subject line, followed by a body that describes the changes. Always include a description in the body, explaining what changed and why.
- Add a co-author trailer in the standard git form `Co-Authored-By: Name <email>`, on its own line after a blank line at the end of the message, using your own model name and an Anthropic no-reply address.
- Output the proposed commit message directly in the conversation, inside a fenced code block so it is easy to copy. Do not run `git commit` or modify the repository in any way.
