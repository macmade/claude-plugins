---
description: Summarize the changes on the current branch versus main/master as application release notes, in Markdown, HTML, or inline.
---

Generate application release notes by comparing the current branch against the base branch, written as Markdown, HTML, or inline. Follow these steps exactly and do not skip the interactive prompts. Never modify the repository: do not commit, push, `git pull`, or `git submodule update`.

## 1. Require a Git repository

- Confirm the current directory is inside a Git working tree (`git rev-parse --is-inside-work-tree`). If it is not, stop and tell the user this command only works inside a Git repository.
- Work from the repository root (`git rev-parse --show-toplevel`).

## 2. Resolve the base branch

- Run `git fetch` to update the remote-tracking branches. This is read-only — never run `git pull`.
- Determine the base branch by preferring `main`, then `master`: use `origin/main` if it exists, otherwise `origin/master`. Check existence with `git rev-parse --verify --quiet <ref>` (or `git branch -r`).
- If neither `origin/main` nor `origin/master` exists, stop and tell the user there is no base branch to compare against.
- Identify the current branch (`git rev-parse --abbrev-ref HEAD`). If it is the same as the resolved base branch, stop and tell the user there is nothing to compare.

## 3. Select submodules to include

- Only consider submodules of the top-level repository (do not recurse into nested submodules). Detect them from `.gitmodules` together with `git submodule status`.
- If there are no submodules, skip this step silently.
- If there are submodules, list them (name and path) and use `AskUserQuestion` with `multiSelect: true` to let the user choose which submodules to also cover. Always allow selecting none — if the user selects none, cover only the top-level repository.

## 4. Collect the changes

- **Top-level repository:**
  - Commits introduced on the current branch: `git log origin/<base>..HEAD`.
  - Code changes: `git diff origin/<base>...HEAD` (three-dot: changes on the current branch since it diverged from the base).
- **Each selected submodule** — summarize only the commits the branch change brings into it (the pointer range), not its whole history:
  - Determine the submodule commit pinned on each side: `git rev-parse origin/<base>:<submodule-path>` (old) and `git rev-parse HEAD:<submodule-path>` (new).
  - If old and new are identical, the submodule did not change on this branch — note it and skip it.
  - Inside the submodule directory, run `git fetch` (read-only) so the pinned commits are available locally. If a needed commit is still missing locally, note that gracefully and summarize only what is available.
  - Commits in the range: `git log <old>..<new>`. Code changes: `git diff <old> <new>`.

## 5. Understand each change

- For every change, read the actual code in the diff and the corresponding commit message(s), and make sure you genuinely understand what changed and why before summarizing. Do not assume — read the surrounding source code when a change is unclear, and consult the Git history if needed.
- Treat the commit message as intent and the diff as ground truth; when they disagree, trust the code.

## 6. Group and summarize

- Group the changes into release-note categories suitable for an application's release notes, for example: **New Features**, **Improvements**, **Bug Fixes**, **Performance**, **Security**, **Other**. Use only the categories that actually have entries; omit empty ones.
- Write every entry as a **bullet point** in clear, user-facing language describing the value or effect of the change — not internal implementation detail. The release notes must consist of bullet points only.
- Merge related commits into a single bullet where that reads better; omit purely internal noise (e.g. formatting-only or chore commits) unless it is user-relevant.
- For each selected submodule that changed, present its bullets in its own grouped subsection, labeled with the submodule name, using the same categories.

## 7. Choose the output format

- Use `AskUserQuestion` as a **single-select** question to ask how the release notes should be produced: **Markdown**, **HTML**, or **Inline**.
  - **Markdown**: write the document to `release-notes.md` in the repository root.
  - **HTML**: write the document to `release-notes.html` in the repository root.
  - **Inline**: report the release notes directly in the conversation, skipping file generation.
- Never overwrite an existing file. For Markdown or HTML, if the target name already exists, append the smallest integer suffix that does not collide (`release-notes-2.md`, `release-notes-3.md`, …) and write to that instead. Report the final filename used.

## 8. Document structure

Every document has the same structure regardless of the output format chosen in step 7. The template below defines the **content** the document must contain — not its formatting. Render each item idiomatically in the chosen format (Markdown or HTML written to the derived file, or presented directly in the conversation for Inline), and replace every `<...>` placeholder.

- **Title** — `<project name> — Release Notes`
- **Generated** — `<YYYY-MM-DD>`
- **Branches** — the comparison: `<current branch>` compared against `origin/<base>`. When submodules were included, also list each covered submodule and its pointer range (`<old short SHA>..<new short SHA>`).
- **Release notes** — the grouped bullet points for the top-level repository, by category (only non-empty categories).
- **Submodules** — for each selected submodule that changed, a subsection titled with the submodule name, containing its grouped bullet points by category. Omit this section entirely if no submodules were covered or none changed.

If there are no user-relevant changes within the scope, say so clearly instead of inventing entries.

### HTML rendering

When the chosen output format is HTML, render the document as a self-contained page with an inline `<style>` block (no external assets), using a dark theme: a dark background with light, comfortably readable text.
