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
- Map each chosen kind to file extensions, then take the **union** and **deduplicate** (so `.h` is included if any of C, C++, or Objective-C is selected):
  - Swift → `.swift`
  - C → `.c` `.h`
  - C++ → `.cpp` `.cc` `.cxx` `.hpp` `.hh`
  - Objective-C → `.m` `.mm` `.h`

## 4. Collect the files

- Work from the repository root (`git rev-parse --show-toplevel`).
- Gather both tracked and untracked files, with submodules and gitignored files excluded automatically:
  ```
  git ls-files
  git ls-files -o --exclude-standard
  ```
- Combine both lists and keep only files whose extension is in the selected set. These commands never descend into submodules, so submodule contents are excluded by construction.

## 5. Confirm and format

- Report how many files matched. If none match, stop and say so.
- Otherwise, run the formatter **once** over all matched files with the chosen configuration, using `xargs` so large file lists are handled safely. For example, with configuration `NAME`:
  ```
  printf '%s\n' "${files[@]}" | xargs "/Applications/Xcode Format.app/Contents/MacOS/Xcode Format" --config "NAME"
  ```
- Do not silence errors: if the formatter writes to stderr or exits non-zero for a file, surface that to the user. Report a short summary of what was formatted when done.
