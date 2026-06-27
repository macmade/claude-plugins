---
description: Summarize the changes since the last release tag as GitHub-ready release notes, in Markdown or inline.
---

Generate GitHub-ready release notes for an upcoming release by comparing the most recent release tag against `HEAD`, written as Markdown or inline. Follow these steps exactly and do not skip the interactive prompts. Never modify the repository: do not commit, push, `git pull`, `git submodule update`, or create tags.

## 1. Require a Git repository

- Confirm the current directory is inside a Git working tree (`git rev-parse --is-inside-work-tree`). If it is not, stop and tell the user this command only works inside a Git repository.
- Work from the repository root (`git rev-parse --show-toplevel`).

## 2. Resolve the previous release tag

- Run `git fetch --tags` to update the remote-tracking branches and tags. This is read-only — never run `git pull`.
- Determine the previous release tag as the most recent tag reachable from `HEAD`: `git describe --tags --abbrev=0`.
- If there are no tags (the command fails or reports none), stop and ask the user how to proceed: either have them provide a starting ref to compare from, or confirm they want the notes to cover the entire history from the first commit. Do not guess.
- Report the resolved previous tag to the user so the comparison range is clear.

## 3. Determine the new version

- Try to detect the new release version automatically:
  - Look for an Xcode project (`*.xcodeproj`) at the repository root (or nearby). Read its `project.pbxproj` and extract `MARKETING_VERSION`. If several targets disagree, prefer the most common value and note the alternatives.
  - If no `MARKETING_VERSION` is found, fall back to `CFBundleShortVersionString` in an `Info.plist`.
- Always confirm with the user using `AskUserQuestion` (single-select). Offer the detected version (if any) as the recommended option, and **always** include an option to enter a version manually. If nothing could be detected, ask the user to provide the version.
- Derive the **new tag name** used for the compare link by reusing the previous tag's prefix convention: if the previous tag was `v1.1.0`, a version of `1.2.0` becomes `v1.2.0`; if the previous tag was `1.1.0`, it becomes `1.2.0`.

## 4. Select submodules to include

- Only consider submodules of the top-level repository (do not recurse into nested submodules). Detect them from `.gitmodules` together with `git submodule status`.
- If there are no submodules, skip this step silently.
- If there are submodules, list them (name and path) and use `AskUserQuestion` with `multiSelect: true` to let the user choose which submodules to also cover. Always allow selecting none — if the user selects none, cover only the top-level repository.
- The generated release notes must be **submodule-agnostic**: do not create submodule-specific sections. Fold any selected submodule's changes into the main project's categories as ordinary features, improvements, fixes, etc., described from the application's point of view.

## 5. Collect the changes

- **Top-level repository:**
  - Commits since the previous release: `git log <prev-tag>..HEAD`.
  - Code changes: `git diff <prev-tag>...HEAD`.
- **Each selected submodule** — summarize only the commits the release brings into it (the pointer range), not its whole history:
  - Determine the submodule commit pinned on each side: `git rev-parse <prev-tag>:<submodule-path>` (old) and `git rev-parse HEAD:<submodule-path>` (new).
  - If old and new are identical, the submodule did not change for this release — skip it silently.
  - Inside the submodule directory, run `git fetch` (read-only) so the pinned commits are available locally. If a needed commit is still missing locally, note that gracefully and summarize only what is available.
  - Commits in the range: `git log <old>..<new>`. Code changes: `git diff <old> <new>`.

## 6. Understand each change

- For every change, read the actual code in the diff and the corresponding commit message(s), and make sure you genuinely understand what changed and why before summarizing. Do not assume — read the surrounding source code when a change is unclear, and consult the Git history if needed.
- Treat the commit message as intent and the diff as ground truth; when they disagree, trust the code.

## 7. Group and summarize

- Group the changes into release-note categories suitable for an application's GitHub release, for example: **New Features**, **Improvements**, **Bug Fixes**, **Performance**, **Security**, **Other**. Use only the categories that actually have entries; omit empty ones.
- Write every entry as a **bullet point** in clear, user-facing language describing the value or effect of the change — not internal implementation detail. The release notes must consist of bullet points only.
- Merge related commits into a single bullet where that reads better; omit purely internal noise (e.g. formatting-only or chore commits) unless it is user-relevant.
- Fold selected submodule changes into these same categories as if they were changes to the main project. Keep them submodule-agnostic — do not mention submodule names or paths.
- Append a PR/issue reference such as `(#123)` to a bullet **only** when it is derivable from a **top-level** commit message (e.g. `(#123)` or `Merge pull request #123`). Never attach PR/issue references derived from submodule commits — those numbers belong to a different repository and would link incorrectly.

## 8. Choose the output format

- Use `AskUserQuestion` as a **single-select** question to ask how the release notes should be produced: **Markdown** or **Inline**.
  - **Markdown**: write the document to `release-notes.md` in the repository root.
  - **Inline**: report the release notes directly in the conversation, skipping file generation. Output the full document inside a fenced code block so the Markdown can be copied and pasted verbatim into a GitHub release. Every line must start at the left margin with no indentation or leading whitespace. Since the notes are themselves Markdown, use an outer fence longer than any backtick run inside the content (e.g. ```` ```` ```` if a bullet contains a triple-backtick block) so the block is not broken.
- Never overwrite an existing file. For Markdown, if `release-notes.md` already exists, append the smallest integer suffix that does not collide (`release-notes-2.md`, `release-notes-3.md`, …) and write to that instead. Report the final filename used.

## 9. Document structure

The output document follows the template below — the release notes only, with no generated date, comparison metadata, preamble, or commentary beyond it. Use GitHub-flavored Markdown, written to `release-notes.md` or presented directly in the conversation for Inline. Replace every `<...>` placeholder, and omit any category section that has no entries.

```markdown
# <project name> <new version>

<A short, one-paragraph description summarizing the release at a glance — its theme or the most notable changes, in user-facing language.>

## New Features

- <bullet> (#123)
- <bullet>

## Improvements

- <bullet>

## Bug Fixes

- <bullet>

## Changelog

**Full Changelog**: <compare URL>
```

- **Title** — `<project name> <new version>` (e.g. `MyApp v1.2.0`).
- **Description** — a short paragraph summarizing the release. Keep it to a couple of sentences; omit it only if there is genuinely nothing to summarize.
- **Category sections** — the grouped bullet points, with PR/issue references appended where derivable per step 7. Use only the categories that have entries, and include other relevant ones (e.g. **Performance**, **Security**, **Other**) in the same style when applicable.
- **Changelog** — a `## Changelog` section whose body is a single line: `**Full Changelog**: <compare URL>`.
  - Derive the repository web URL from `git remote get-url origin`, converting an SSH remote (`git@github.com:<owner>/<repo>.git`) or HTTPS remote to `https://github.com/<owner>/<repo>`.
  - Build the compare URL as `https://github.com/<owner>/<repo>/compare/<prev-tag>...<new-tag>` using the new tag name derived in step 3.
  - If `origin` is missing, is not a GitHub remote, or cannot be parsed, omit the entire `## Changelog` section gracefully.

If there are no user-relevant changes within the scope, say so clearly instead of inventing entries.
