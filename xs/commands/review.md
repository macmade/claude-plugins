---
description: Perform a full, in-depth code review (whole repository, uncommitted changes, or a branch comparison), reporting the findings as Markdown, HTML, or inline.
---

Perform a full, in-depth code review of the project. Follow these steps exactly.

## 1. Choose the review scope

- Before anything else, confirm the current directory is inside a Git working tree (`git rev-parse --is-inside-work-tree`); if it is not, stop and tell the user this command only works inside a Git repository.
- First, from the repository root, detect which change scopes actually contain files:
  - **Staged** — `git diff --cached --name-only` returns at least one file.
  - **Unstaged** — `git diff --name-only` returns at least one file.
  - **Untracked** — `git ls-files -o --exclude-standard` returns at least one file.
- Use `AskUserQuestion` as a **single-select** question to ask what the review should cover. Always offer **Whole repository** and **Compare against a branch**; in addition, offer **Uncommitted changes** as a single option, but **only** when at least one of the staged, unstaged, or untracked scopes detected above contains files. Never offer **Uncommitted changes** when there are no local changes at all.
  - **Whole repository**: review all files in the repository.
  - **Uncommitted changes**: review all local changes together — the union of the staged changes (`git diff --cached`), the unstaged changes to tracked files (`git diff`), and the untracked files (`git ls-files -o --exclude-standard`), along with the context needed to understand them. Read untracked files directly, since they do not appear in `git diff`. Include only the scopes that actually contain files.
  - **Compare against a branch**: review only the changes between the current branch and a chosen base branch.
- If **Compare against a branch** is selected, determine the base branch:
  - First, run `git fetch` to update the remote-tracking branches so the comparison is against the current remote state. This is read-only — never run `git pull`.
  - List the available remote branches with `git branch -r` (the `origin` remote). Work with the remote branches only — never the local ones.
  - From that list, propose as quick-pick options the following, and only when they actually exist on `origin`: `origin/main`, `origin/master`, `origin/release`, `origin/hotfix`, `origin/development`. Always add an **Other branch** option as well.
  - Use `AskUserQuestion` as a **single-select** question to let the user pick the base branch.
  - If the user picks **Other branch**, present a second `AskUserQuestion` single-select listing all available remote branches from `git branch -r` (excluding `origin/HEAD` and the remote-tracking branch for the current branch) so the user can choose any one.
  - Review only the changes reported by `git diff <base-branch>...HEAD`, along with the context needed to understand them.

## 2. Choose the output format and location

- Use `AskUserQuestion` as a **single-select** question to ask how the findings should be reported: **Markdown**, **HTML**, or **Inline**.
  - **Markdown**: write the report as a Markdown file.
  - **HTML**: write the report as an HTML file.
  - **Inline**: report the findings directly in the conversation, skipping file generation.
- **Choose the location** — only when writing to a file (Markdown or HTML); skip this entirely for Inline. Use `AskUserQuestion` as a **single-select** question to ask where to write the report, offering exactly these two options (always include both, whether or not `Docs/agent-plans/active` already exists):
  - **Repository root** — write directly to the repository root.
  - **Docs/agent-plans** — write into a dated subfolder of `Docs/agent-plans/active`, creating the `Docs/agent-plans/active` directory (and the subfolder) if it does not already exist.
  - This location question and the format question above may be asked together in a single `AskUserQuestion` call.
- **Derive the path** from the chosen format and location, using the base name `code-review` and the extension `md` or `html` per the chosen format:
  - **Repository root:** write `code-review.<ext>` directly in the repository root (e.g. `code-review.md`, `code-review.html`).
  - **Docs/agent-plans:** create a subfolder named `<YYYY-MM-DD>-code-review` (using today's date) under `Docs/agent-plans/active` and write the file as `code-review.<ext>` inside it (e.g. `Docs/agent-plans/active/2026-05-17-code-review/code-review.md`).
- Never overwrite an existing file. Append the smallest integer suffix that does not collide, applied to whichever part of the path keeps reports from clashing:
  - **Repository root:** suffix the filename (`code-review-2.md`, `code-review-3.md`, …).
  - **Docs/agent-plans:** suffix the dated subfolder, keeping the filename inside it unchanged (`Docs/agent-plans/active/2026-05-17-code-review-2/code-review.md`, …).
  - Report the final path used.

## 3. Perform the review

- Perform a complete, in-depth review within the chosen scope. Make sure to read the relevant source code and do not assume anything.
- Read the Git history, if necessary or in doubt, to understand why certain decisions were made.
- Back up your claims.
- Focus on everything, including architecture, API, performance, security, stability, crashes, undefined behavior, etc.
- When reviewing changes (uncommitted changes or a branch comparison), explicitly check for **regressions**: behavior, APIs, or guarantees that previously worked and are now altered, removed, or broken — including impacts on existing callers and tests.
- Report your findings using the template in the next step, in the chosen format: at the derived path for Markdown or HTML, or directly in the conversation for Inline.

## 4. Report template

Every report has the same structure regardless of the output format chosen in step 2. The template below defines the **content** the report must contain — not its formatting. Render each item idiomatically in the chosen format (Markdown or HTML written to the derived path, or presented directly in the conversation for Inline), and replace every `<...>` placeholder.

- **Title** — `<project name> — Code Review`
- **Generated** — `<YYYY-MM-DD>`
- **Scope** — exactly what was reviewed: the whole repository, the uncommitted changes, or a comparison against `<base-branch>` (`git diff <base-branch>...HEAD`).
- **Summary** — one or two paragraphs: the overall assessment and the most important takeaways, followed by a count of findings per severity.
- **Notes** — an optional, free-form section between the summary and the findings for anything useful to capture before diving into the findings: relevant context, key files or components reviewed, assumptions made, conventions observed, scope caveats, or areas deliberately not covered. Include only what is genuinely helpful; omit the section if there is nothing worth recording.
- **Findings** — the core of the report. List findings grouped by severity, highest first (or by area when that is clearer). Repeat one entry per finding. Each finding contains:
  - **Title** — `<short description of the issue>`
  - **Severity** — one of: `Critical`, `High`, `Medium`, `Low`, `Info`
  - **Category** — e.g. architecture, API, performance, security, stability, crash, undefined behavior, regression, style
  - **Location** — the file and line(s) it refers to (`path/to/file:line`), or several locations when relevant. Omit only when a finding is genuinely repository-wide.
  - **Description** — what the issue is and why it matters, backed by evidence from the code.
  - **Recommendation** — a concrete suggestion for how to address it.
  - For change-based reviews (uncommitted changes or a branch comparison), mark a finding as a **regression** when it qualifies.
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
