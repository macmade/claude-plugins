---
description: Turn a source document (code review, roadmap, refactor notes, etc.) into a milestone-based implementation plan.
argument-hint: "[source-file]"
---

Turn a source document into a milestone-based implementation plan. The source can be any Markdown or HTML document — a code review, a roadmap, refactor notes, a design doc, etc. Follow these steps exactly.

## 1. Determine the source file

- If a filename was provided as an argument (`$ARGUMENTS`), use it as the source document.
- Otherwise, find candidate documents in the repository and ask the user which one to use:
  - List `*.md` and `*.html` files (e.g. `git ls-files '*.md' '*.html'` plus untracked ones via `git ls-files -o --exclude-standard '*.md' '*.html'`), excluding files that already look like plans (names ending in `-plan.md` / `-plan.html`) and the project's `README.md`.
  - Present them with `AskUserQuestion` as a **single-select** question. If no candidates exist, stop and tell the user.
- If the chosen file does not exist, stop and say so.

## 2. Choose the output format and derive the plan filename

- Use `AskUserQuestion` as a **single-select** question to ask whether the plan should be written in **Markdown** or **HTML**. Default the recommendation to the source's own format.
- Build the output name from the source, keeping its directory: `<base>-plan.<ext>`, where `<ext>` is `md` or `html` per the chosen format.
  - source `code-review.html`, HTML → `code-review-plan.html`
  - source `roadmap.md`, Markdown → `roadmap-plan.md`
  - source `docs/refactor.html`, Markdown → `docs/refactor-plan.md`
- Write the plan in the chosen format.

## 3. Create the plan

- Read and understand the source document fully.
- Ask the user any clarifying questions needed before planning.
- If the project uses submodules and you think a change is needed in one of them to improve the implementation, ask the user. Changes to submodules may be acceptable, but the user decides on a case-by-case basis.
- Split the plan into small, meaningful milestones that can be reviewed and committed individually, and write it to the derived plan file.
- Write the plan as a living document: give each milestone a clear place to record implementation status, iterations, and review comments, since the implement command updates the plan in place as work progresses.
