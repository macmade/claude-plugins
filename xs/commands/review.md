---
description: Perform a full, in-depth code review of the project, writing the findings to a Markdown or HTML file.
---

Perform a full, in-depth code review of the project. Follow these steps exactly.

## 1. Choose the review scope

- First, from the repository root, detect which change scopes actually contain files:
  - **Staged** — `git diff --cached --name-only` returns at least one file.
  - **Unstaged** — `git diff --name-only` returns at least one file.
  - **Untracked** — `git ls-files -o --exclude-standard` returns at least one file.
- Use `AskUserQuestion` as a **single-select** question to ask what the review should cover. Always offer **Whole repository** and **Compare against a branch**; in addition, offer each of **Staged**, **Unstaged**, and **Untracked** as separate options, but **only** for the scopes detected above. Never offer a change scope that has no files.
  - **Whole repository**: review all files in the repository.
  - **Staged**: review only the staged changes (`git diff --cached`), along with the context needed to understand them.
  - **Unstaged**: review only the unstaged changes to tracked files (`git diff`), along with the context needed to understand them.
  - **Untracked**: review only the untracked files (`git ls-files -o --exclude-standard`). Read these files directly, since they do not appear in `git diff`.
  - **Compare against a branch**: review only the changes between the current branch and a chosen base branch.
- If **Compare against a branch** is selected, determine the base branch:
  - List the available remote branches with `git branch -r` (the `origin` remote). Work with the remote branches only — never the local ones.
  - From that list, propose as quick-pick options the following, and only when they actually exist on `origin`: `origin/main`, `origin/master`, `origin/release`, `origin/hotfix`, `origin/development`. Always add an **Other branch** option as well.
  - Use `AskUserQuestion` as a **single-select** question to let the user pick the base branch.
  - If the user picks **Other branch**, present a second `AskUserQuestion` single-select listing all available remote branches from `git branch -r` (excluding `origin/HEAD` and the remote-tracking branch for the current branch) so the user can choose any one.
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
- When reviewing changes (staged, unstaged, untracked, or a branch comparison), explicitly check for **regressions**: behavior, APIs, or guarantees that previously worked and are now altered, removed, or broken — including impacts on existing callers and tests.
- Report your findings using the template in the next step, in the chosen format: at the derived filename for Markdown or HTML, or directly in the conversation for Inline.

## 4. Report template

Every report has the same structure regardless of the output format chosen in step 2. The template below defines the **content** the report must contain — not its formatting. Render each item idiomatically in the chosen format (Markdown or HTML written to the derived file, or presented directly in the conversation for Inline), and replace every `<...>` placeholder.

- **Title** — `<project name> — Code Review`
- **Generated** — `<YYYY-MM-DD>`
- **Scope** — exactly what was reviewed: the whole repository, the staged changes, the unstaged changes, the untracked files, or a comparison against `<base-branch>` (`git diff <base-branch>...HEAD`).
- **Summary** — one or two paragraphs: the overall assessment and the most important takeaways, followed by a count of findings per severity.
- **Notes** — an optional, free-form section between the summary and the findings for anything useful to capture before diving into the findings: relevant context, key files or components reviewed, assumptions made, conventions observed, scope caveats, or areas deliberately not covered. Include only what is genuinely helpful; omit the section if there is nothing worth recording.
- **Findings** — the core of the report. List findings grouped by severity, highest first (or by area when that is clearer). Repeat one entry per finding. Each finding contains:
  - **Title** — `<short description of the issue>`
  - **Severity** — one of: `Critical`, `High`, `Medium`, `Low`, `Info`
  - **Category** — e.g. architecture, API, performance, security, stability, crash, undefined behavior, regression, style
  - **Location** — the file and line(s) it refers to (`path/to/file:line`), or several locations when relevant. Omit only when a finding is genuinely repository-wide.
  - **Description** — what the issue is and why it matters, backed by evidence from the code.
  - **Recommendation** — a concrete suggestion for how to address it.
  - For change-based reviews (staged, unstaged, untracked, or a branch comparison), mark a finding as a **regression** when it qualifies.
- **Strengths** — an optional section for notable things done well. Include only if genuinely worth noting; omit otherwise.
- **Appendix** — an optional, free-form section at the very end for supporting material that does not belong to a single finding: longer code excerpts, diagrams, references, or extra detail. Include only what is genuinely helpful; omit if there is nothing worth recording.

If no issues are found within the scope, say so clearly instead of inventing findings.

### HTML rendering

When the chosen output format is HTML, render the report as a self-contained document with an inline `<style>` block (no external assets), using a dark theme: a dark background with light, comfortably readable text.

Render each finding's Severity as a colored capsule — a small pill with rounded corners, padding, and a colored background — rather than plain text. Use a distinct color per severity, for example:

- **Critical** — red
- **High** — orange
- **Medium** — amber
- **Low** — blue
- **Info** — neutral / gray

Keep the capsule colors legible against the dark background.
