---
description: Generate a roadmap file in Markdown or HTML from points entered one at a time, or extend an existing roadmap.
argument-hint: "[existing-roadmap-file]"
---

Generate a project roadmap from points entered one at a time, written to a Markdown or HTML file. Follow these steps exactly and do not skip the interactive prompts.

## 1. Determine whether to extend an existing roadmap

- If a filename was provided as an argument (`$ARGUMENTS`), treat it as an existing roadmap to extend:
  - If the file does not exist, stop and say so.
  - Read it fully to understand its title, structure, conventions, and existing points.
  - Detect its format from the extension: `.md` → Markdown, `.html` → HTML.
  - **Skip** the title question (step 2) and the output format question (step 5): reuse the existing title and write back to the same file in its existing format. The new points are appended to the existing roadmap (see step 6).
- Otherwise, you are creating a new roadmap. Continue with the title question below.

## 2. Choose the roadmap title

- Only when creating a new roadmap (no argument was provided).
- Ask the user for the roadmap title. Use this title for the document and to derive the filename in step 5.

## 3. Collect the roadmap points

- Collect the points one at a time using `AskUserQuestion`. In each prompt, ask two things together:
  - The point text: the user types the next point as free text, and you also offer a **Finished** option to indicate there are no more points.
  - The point's **priority**: a single-select list of `High`, `Normal`, `Low`, with `Normal` as the default (list it first).
- After capturing a point and its priority, repeat the prompt for the next one. Continue until the user selects **Finished**.
- Require at least one point. If the user selects **Finished** before entering any point, ask them to add at least one.
- Capture each point's text verbatim as the user enters it; do not rewrite it yet. You will refine wording in step 4. Keep the priority the user chose for each point.

## 4. Understand the points

- If the current directory is inside a Git repository (`git rev-parse --is-inside-work-tree`), analyze the repository to make sure you actually understand each roadmap point in the context of the codebase. Read the relevant source code — do not assume anything.
- Ask the user any clarifying questions needed to capture each point accurately, and record every question you asked together with the user's answer in the roadmap's Questions & answers section (see the template).
- When extending an existing roadmap, also read its existing points so the new ones are consistent with what is already there and not redundant.
- If you are not inside a repository, skip the repository analysis but still ask clarifying questions if a point is ambiguous.

## 5. Choose the output format and derive the roadmap filename

- Only when creating a new roadmap (when extending, reuse the existing file and format from step 1).
- Use `AskUserQuestion` as a **single-select** question to ask whether the roadmap should be written in **Markdown** or **HTML**.
- Derive the filename from the title: lowercase it, replace any run of non-alphanumeric characters with a single hyphen, and trim leading/trailing hyphens. Use the extension `md` or `html` per the chosen format. Write it in the current directory.
  - title `Project Phoenix`, Markdown → `project-phoenix.md`
  - title `Q3 2026 Roadmap`, HTML → `q3-2026-roadmap.html`

## 6. Write the roadmap

- When creating a new roadmap, structure it using the template in the next step, rendering it idiomatically in the chosen output format, and write it to the derived filename.
- When extending an existing roadmap, append the new points to the existing document, matching its existing structure and formatting rather than imposing the template. Keep all existing points unchanged, add the new ones in the same style, and update the document's generated/updated date if it has one.

## 7. Roadmap template

Every roadmap has the same structure regardless of the output format chosen in step 5. The template below defines the **content** the roadmap must contain — not its formatting. Render each item idiomatically in the chosen format (Markdown or HTML), and replace every `<...>` placeholder.

- **Title** — `<roadmap title>`
- **Generated** — `<YYYY-MM-DD>`
- **Overview** — an optional paragraph or two describing the purpose and theme of the roadmap. Include only if it adds value; omit otherwise.
- **Questions & answers** — every clarifying question you asked while building the roadmap, each paired with the user's answer. Omit the section only if no questions were asked.
- **Notes** — an optional, free-form section between the overview and the points for anything useful to capture: relevant context, key files or components, assumptions, dependencies, or references. Include only what is genuinely helpful; omit the section if there is nothing worth recording.
- **Roadmap** — the core of the document: the points in order, repeated one entry per point. Each point contains:
  - **Title** — `<short title for the point>`
  - **Description** — what the point is and why it matters, refined from the user's text with the context gathered in step 4.
  - **Priority** — one of: `High`, `Normal`, `Low`, as chosen by the user in step 3. Default to `Normal`.
- **Appendix** — an optional, free-form section at the very end for supporting material that does not belong to a single point: diagrams, references, or extra detail. Include only what is genuinely helpful; omit the section if there is nothing worth recording.

### HTML rendering

When the chosen output format is HTML, render the roadmap as a self-contained document with an inline `<style>` block (no external assets), using a dark theme: a dark background with light, comfortably readable text.

Render each point's Priority as a colored capsule — a small pill with rounded corners, padding, and a colored background — rather than plain text. Use a distinct color per priority, for example:

- **High** — red
- **Normal** — neutral / gray
- **Low** — blue

Keep the capsule colors legible against the dark background.
