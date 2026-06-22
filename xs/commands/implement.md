---
description: Implement a plan file milestone by milestone, pausing after each for manual review and commit.
argument-hint: "[plan-file]"
---

Implement a milestone-based plan, one milestone at a time. The plan can be any Markdown or HTML plan file. Follow these steps exactly.

## 1. Determine the plan file

- If a filename was provided as an argument (`$ARGUMENTS`), use it as the plan file.
- Otherwise, find candidate plan documents in the repository and ask the user which one to use:
  - List plan files (names ending in `-plan.md` / `-plan.html`) via `git ls-files '*-plan.md' '*-plan.html'` plus untracked ones via `git ls-files -o --exclude-standard '*-plan.md' '*-plan.html'`. If none are found, fall back to listing all `*.md` / `*.html` files, excluding the project's `README.md`.
  - Present them with `AskUserQuestion` as a **single-select** question. If no candidates exist, stop and tell the user.
- If the chosen file does not exist, stop and say so.

## 2. Choose the implementation approach

- Ask the user with `AskUserQuestion` whether to implement using TDD (test-driven development) or not. Offer both options clearly:
  - **TDD** — write the tests first, watch them fail, then implement until they pass.
  - **Without TDD** — implement directly, adding tests as appropriate.
- Use the chosen approach for every milestone in the next step.

## 3. Implement

- Read the plan file. Implement each milestone one by one, using the approach chosen in step 2.
- Pause after each milestone so the user can review and commit manually.
- Provide a commit message. Follow Conventional Commits. Look at the previous commits (`git log`) for the types, scopes, and style actually used in this repository, and match them.
- Use a concise, imperative subject line, followed by a body that describes the changes. Always include a description in the body, explaining what changed and why. Do not mention milestones in the commit message.
- Add a co-author trailer in the standard git form `Co-Authored-By: Name <email>`, on its own line after a blank line at the end of the message, using your own model name and an Anthropic no-reply address.
- Update the plan file as you go, with implementation status, iterations, and review comments for each milestone.
- When completing a milestone, also mention the date it was completed in its implementation section.
