---
description: Perform a full, in-depth code review of the project, writing the findings to a Markdown or HTML file.
---

Perform a full, in-depth code review of the project. Follow these steps exactly.

## 1. Choose the output format

- Use `AskUserQuestion` as a **single-select** question to ask whether the findings should be written in **Markdown** or **HTML**.
- Write the report to `code-review.md` or `code-review.html` accordingly.

## 2. Perform the review

- Perform a complete, in-depth review. Make sure to read the whole source code and do not assume anything.
- Read the Git history, if necessary or in doubt, to understand why certain decisions were made.
- Back up your claims.
- Focus on everything, including architecture, API, performance, security, stability, crashes, undefined behavior, etc.
- Report your findings in the chosen format at the derived filename.
