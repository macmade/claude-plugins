---
description: Reformat repository source files with Xcode Format, choosing a configuration and file kinds interactively.
---

Reformat source files in the current repository using **Xcode Format**. Follow these steps exactly and do not skip the interactive prompts.

## 1. Preflight

- This only works on macOS. If `uname -s` is not `Darwin`, stop and tell the user.
- The formatter lives at `/Applications/Xcode Format.app/Contents/MacOS/Xcode Format`. If that file is not executable, stop and tell the user the tool is not installed.

## 2. Choose the configuration (single selection)

- Run the formatter to list configurations:
  ```
  "/Applications/Xcode Format.app/Contents/MacOS/Xcode Format" --list
  ```
- Each line of output is one configuration name. Present them to the user with `AskUserQuestion` as a **single-select** question (one config per run). Build the options dynamically from the command output — never hardcode the names, so new configurations appear automatically.

## 3. Choose the file kinds (multiple selection)

- Use `AskUserQuestion` with `multiSelect: true` to let the user pick one or more of: **Swift**, **C**, **C++**, **Objective-C**.
- Map each chosen kind to file extensions, then take the **union** and **deduplicate** (so `.h` is included if either C or Objective-C is selected):
  - Swift → `.swift`
  - C → `.c` `.h`
  - C++ → `.cpp` `.cc` `.cxx` `.hpp` `.hh`
  - Objective-C → `.m` `.mm` `.h`

## 4. Choose the file scope (multiple selection)

- First, detect which change-based scopes actually contain files: **Staged** (`git diff --cached --name-only`), **Unstaged** (`git diff --name-only`), **Untracked** (`git ls-files -o --exclude-standard`).
- Use `AskUserQuestion` with `multiSelect: true` so the user can pick one scope or any combination of scopes. Always offer **All files** (it does not depend on local changes), and among the change-based scopes offer **only** those detected above — never present a change-based scope that has no files:
  - **All files** — every tracked and untracked file in the repository.
  - **Staged** — files staged for commit (the index).
  - **Unstaged** — tracked files with unstaged modifications in the working tree.
  - **Untracked** — files not yet tracked by git.
- If **All files** is selected, ignore the other choices and use the full repository set. Otherwise take the **union** of the selected scopes and deduplicate.

## 5. Collect the files

- Work from the repository root (`git rev-parse --show-toplevel`).
- For each selected scope, gather the corresponding files. All commands below exclude submodules and gitignored files by construction, and `--diff-filter=d` drops deleted paths so the formatter never runs on a file that no longer exists:
  - **All files** → `git ls-files` and `git ls-files -o --exclude-standard`
  - **Staged** → `git diff --cached --name-only --diff-filter=d`
  - **Unstaged** → `git diff --name-only --diff-filter=d`
  - **Untracked** → `git ls-files -o --exclude-standard`
- Combine the lists for every selected scope, deduplicate, and keep only files whose extension is in the set chosen in step 3.

## 6. Confirm and format

- Report how many files matched. If none match, stop and say so.
- Otherwise, run the formatter **once** over all matched files with the chosen configuration, using `xargs` so large file lists are handled safely. Delimit the paths with NUL and use `xargs -0` so file names containing spaces are handled correctly. For example, with configuration `NAME`:
  ```
  printf '%s\0' "${files[@]}" | xargs -0 "/Applications/Xcode Format.app/Contents/MacOS/Xcode Format" --config "NAME"
  ```
- Do not silence errors: if the formatter writes to stderr or exits non-zero for a file, surface that to the user. Report a short summary of what was formatted when done.
