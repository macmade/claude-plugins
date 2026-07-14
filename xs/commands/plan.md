---
description: Turn a source document (code review, backlog, refactor notes, etc.) into a milestone-based implementation plan.
argument-hint: "[source-file]"
---

Turn a source document into a milestone-based implementation plan. The source can be any Markdown or HTML document — a code review, a backlog, refactor notes, a design doc, etc. Follow these steps exactly.

## 1. Determine the source file

- If a filename was provided as an argument (`$ARGUMENTS`), use it as the source document.
- Otherwise, find candidate documents in the repository and ask the user which one to use. This fallback needs a Git repository — if the current directory is not inside a Git working tree (`git rev-parse --is-inside-work-tree`), stop and ask the user to pass a source file as an argument instead:
  - List `*.md` and `*.html` files (e.g. `git ls-files '*.md' '*.html' ':(exclude)Docs/agent-plans/completed/**'` plus untracked ones via `git ls-files -o --exclude-standard '*.md' '*.html' ':(exclude)Docs/agent-plans/completed/**'`), then exclude:
    - files that already look like plans (names ending in `-plan.md` / `-plan.html`);
    - source files that already have an associated plan (e.g. exclude `backlog.md` when `backlog-plan.md` or `backlog-plan.html` exists alongside it);
    - standard repository boilerplate (README, LICENSE / COPYING, CODE_OF_CONDUCT, CONTRIBUTING, CHANGELOG, SECURITY, and similar conventional project files, regardless of extension or directory).
  - If a `Docs/agent-plans/active` directory exists at the repository root, favor the candidates found under it: list those first and mark them as recommended, but keep listing the candidates found elsewhere too. (Finished initiatives under `Docs/agent-plans/completed` are already excluded by the `:(exclude)` pathspec above, so they never reach this list.)
  - Present them with `AskUserQuestion` as a **single-select** question. If no candidates exist, stop and tell the user.
- If the chosen file does not exist, stop and say so.

## 2. Choose the output format and derive the plan filename

- Use `AskUserQuestion` as a **single-select** question to ask whether the plan should be written in **Markdown** or **HTML**. Default the recommendation to the source's own format.
- Build the output name from the source, keeping its directory: `<base>-plan.<ext>`, where `<ext>` is `md` or `html` per the chosen format.
  - source `code-review.html`, HTML → `code-review-plan.html`
  - source `backlog.md`, Markdown → `backlog-plan.md`
  - source `docs/refactor.html`, Markdown → `docs/refactor-plan.md`
- Never overwrite an existing file. If the derived name already exists, append the smallest integer suffix that does not collide (`code-review-plan-2.md`, `code-review-plan-3.md`, …) and write to that instead. Report the final filename used.
- Write the plan in the chosen format.

## 3. Create the plan

- Read and understand the source document fully.
- Ask the user any clarifying questions needed before planning, and record every question you asked together with the user's answer in the plan's Questions & answers section (see the template). Record only questions about the plan's content; never record the mechanical questions from steps 1 and 2 (which source file to use, the output format, or the plan's filename and location).
- If the project uses submodules and you think a change is needed in one of them to improve the implementation, ask the user. Changes to submodules may be acceptable, but the user decides on a case-by-case basis.
- Split the plan into small, meaningful milestones that can be reviewed and committed individually, and write it to the derived plan file.
- Write the plan as a living document: give each milestone a clear place to record implementation status, iterations, and review comments, since the implement command updates the plan in place as work progresses.
- Include the date the plan was generated at the top of the file.
- Always structure the plan using the template in the next step, rendering it idiomatically in the chosen output format. Use this template even if a plan file already exists in the repository — never copy the structure of an existing plan. Add as many milestones as the work requires, and fill in every placeholder.

## 4. Plan template

Every plan has the same structure regardless of the output format chosen in step 2. The template below defines the **content** the plan must contain — not its formatting. Render each item idiomatically in the chosen format (Markdown or HTML), and replace every `<...>` placeholder.

- **Title** — `<plan title>`
- **Generated** — `<YYYY-MM-DD>`
- **Source** — `<path to the source document>`
- **Overview** — `<one or two paragraphs: the goal of this plan and the overall approach>`
- **Questions & answers** — every clarifying question you asked about the plan's content, each paired with the user's answer. Exclude the mechanical questions from steps 1 and 2 (which source file to use, the chosen output format, and the plan's filename and location) — these belong to the planning process, not the plan. Omit the section only if no content questions were asked.
- **Notes** — an optional, free-form section between the overview and the milestones for anything you find useful to capture before diving into the milestones: relevant context, key files or components, conventions to follow, assumptions, open questions, risks, or references. Include only what is genuinely helpful; omit the section if there is nothing worth recording.
- **Table of contents** — a milestone index placed just before the milestones themselves. List every milestone in order, and for each entry: a link to that milestone's own section below, plus its current **Status**. When milestones are grouped under named phases, mirror that grouping in the table of contents. Render it idiomatically in the chosen format: in Markdown, a list of links to the milestone headings (using their auto-generated heading anchors) with the status shown beside each; in HTML, a list of anchor links (`href="#<milestone-id>"`) with the status shown as the same colored capsule used on the milestone itself. Every entry's status must always match the status of the milestone it links to — the implement command keeps the two in sync as work progresses.
- **Milestones** — one entry per milestone, repeated as many times as the work requires. For large plans, group related milestones under named phases when it makes the plan clearer; otherwise list the milestones directly. Give each milestone a stable anchor so the table of contents can link to it: a Markdown heading produces one automatically, and in HTML add an explicit `id` to the milestone's heading or container. Each milestone contains:
  - **Title** — `<short milestone title>`
  - **Goal** — `<what this milestone achieves and why>`
  - **Tasks** — a checklist of the concrete steps to complete the milestone
  - **Status** — one of: `Not started`, `In progress`, `Completed`
  - **Completed** — `<the date it was completed, once done; otherwise left blank>`
  - **Implementation notes** — filled in as work progresses: what was done, decisions made, iterations
  - **Automated review** — findings from the automated review loop run during implementation (kept separate from human review feedback)
  - **Review comments** — human review feedback for this milestone
- **Appendix** — an optional, free-form section at the very end for supporting material that does not belong to a single milestone: detailed examples, diagrams, data, references, or any extra detail worth keeping out of the main flow. Include only what is genuinely helpful; omit the section if there is nothing worth recording.

Keep the per-milestone Status, Completed, Implementation notes, Automated review, and Review comments fields so the implement command can update them in place.

### HTML rendering

When the chosen output format is HTML, render the plan as a self-contained document with an inline `<style>` block (no external assets), using a dark theme: a dark background with light, comfortably readable text.

Render each milestone's Status as a colored capsule — a small pill with rounded corners, padding, and a colored background — rather than plain text. Use a distinct color per status, for example:

- **Not started** — neutral / gray
- **In progress** — amber or blue
- **Completed** — green

Keep the capsule colors legible against the dark background. Use the same status capsules in the table of contents, and give each milestone an `id` so the table-of-contents links resolve.

## 5. Open the plan file

- After writing the plan, open it in the platform's default application so it appears for the user right away. Pick the command that matches the current platform: `open "<path>"` on macOS, `xdg-open "<path>"` on Linux, or `start "" "<path>"` on Windows. Use the final filename derived in step 2, including any collision suffix.
