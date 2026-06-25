---
description: Document every type and member with SwiftDoc or HeaderDoc comments, choosing the language and scope interactively.
---

Document every type and member in the chosen source files, including private and internal members. Validate existing comments and convert them to the selected style if necessary. Follow these steps exactly and do not skip the interactive prompts.

## 1. Choose the documentation style (single selection)

- Use `AskUserQuestion` as a **single-select** question to let the user pick one of:
  - **Swift (SwiftDoc)** — Swift files documented with SwiftDoc comments.
  - **C / C++ / Objective-C (HeaderDoc)** — C-family files documented with HeaderDoc comments.
- Map the chosen style to its file extensions:
  - Swift (SwiftDoc) → `.swift`
  - C / C++ / Objective-C (HeaderDoc) → `.c` `.h` `.m` `.mm` `.cpp` `.cc` `.cxx` `.hpp` `.hh`

## 2. Choose the file scope (multiple selection)

- Use `AskUserQuestion` with `multiSelect: true` so the user can pick one scope or any combination of scopes:
  - **All files** — every tracked and untracked file in the repository.
  - **Staged** — files staged for commit (the index).
  - **Unstaged** — tracked files with unstaged modifications in the working tree.
  - **Untracked** — files not yet tracked by git.
- If **All files** is selected, ignore the other choices and use the full repository set. Otherwise take the **union** of the selected scopes and deduplicate.

## 3. Collect the files

- Work from the repository root (`git rev-parse --show-toplevel`).
- For each selected scope, gather the corresponding files. All commands below exclude submodules and gitignored files by construction, and `--diff-filter=d` drops deleted paths so no missing file is processed:
  - **All files** → `git ls-files` and `git ls-files -o --exclude-standard`
  - **Staged** → `git diff --cached --name-only --diff-filter=d`
  - **Unstaged** → `git diff --name-only --diff-filter=d`
  - **Untracked** → `git ls-files -o --exclude-standard`
- Combine the lists for every selected scope, deduplicate, and keep only files whose extension is in the set chosen in step 1. These commands never descend into submodules, so submodule contents are excluded by construction.
- Report how many files matched. If none match, stop and say so.

## 4. Document the code

- Make sure to read and understand what the code does before documenting it.
- For each matched file, document every type and member — including private and internal ones — using the comment style chosen in step 1 (SwiftDoc for Swift, HeaderDoc for C / C++ / Objective-C).
- Validate any existing comments and convert them to the selected style if necessary.

## 5. Commit message

- Follow Conventional Commits. Look at the previous commits (`git log`) for the types, scopes, and style actually used in this repository, and match them.
- Use a concise, imperative subject line, followed by a body that describes the changes. Always include a description in the body, explaining what changed and why.
- Add a co-author trailer in the standard git form `Co-Authored-By: Name <email>`, on its own line after a blank line at the end of the message, using your own model name and an Anthropic no-reply address.
- Output the proposed commit message directly in the conversation, inside a fenced code block so it is easy to copy. Every line of the message must start at the left margin with no indentation or leading whitespace, so it can be copied and pasted verbatim. Do not stage or commit anything — leave that to the user.
