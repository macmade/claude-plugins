---
description: Perform a full, in-depth code review of the project, writing the findings to a Markdown or HTML file.
---

Perform a full, in-depth code review of the project. Follow these steps exactly.

## 1. Choose the review scope

- Use `AskUserQuestion` as a **single-select** question to ask whether the review should cover the **whole repository**, only the **staged/unstaged changes**, or a **comparison against another branch**.
  - **Whole repository**: review all files in the repository.
  - **Staged/unstaged changes**: review only the changes reported by `git status` and `git diff` (both staged and unstaged), along with the context needed to understand them.
  - **Compare against a branch**: review only the changes between the current branch and a chosen base branch.
- If **Compare against a branch** is selected, determine the base branch:
  - List the available branches with `git branch`.
  - From that list, propose as quick-pick options the following, and only when they actually exist in the repository: `main`, `master`, `release`, `hotfix`, `development`. Always add an **Other branch** option as well.
  - Use `AskUserQuestion` as a **single-select** question to let the user pick the base branch.
  - If the user picks **Other branch**, present a second `AskUserQuestion` single-select listing all available branches from `git branch` (excluding the current branch) so the user can choose any one.
  - Review only the changes reported by `git diff <base-branch>...HEAD`, along with the context needed to understand them.

## 2. Choose the output format

- Use `AskUserQuestion` as a **single-select** question to ask how the findings should be reported: **Markdown**, **HTML**, or **Inline**.
  - **Markdown**: write the report to `code-review.md`.
  - **HTML**: write the report to `code-review.html`.
  - **Inline**: report the findings directly in the conversation, skipping file generation.

## 3. Perform the review

- Perform a complete, in-depth review within the chosen scope. Make sure to read the relevant source code and do not assume anything.
- Read the Git history, if necessary or in doubt, to understand why certain decisions were made.
- Back up your claims.
- Focus on everything, including architecture, API, performance, security, stability, crashes, undefined behavior, etc.
- When reviewing changes (staged/unstaged or a branch comparison), explicitly check for **regressions**: behavior, APIs, or guarantees that previously worked and are now altered, removed, or broken — including impacts on existing callers and tests.
- Report your findings in the chosen format: at the derived filename for Markdown or HTML, or directly in the conversation for Inline.
- When writing to a file (Markdown or HTML), include the date the review was generated at the top of the file.
