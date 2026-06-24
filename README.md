claude-plugins
==============

[![Issues](http://img.shields.io/github/issues/macmade/claude-plugins.svg?logo=github)](https://github.com/macmade/claude-plugins/issues)
![Status](https://img.shields.io/badge/status-active-brightgreen.svg?logo=git)
![License](https://img.shields.io/badge/license-mit-brightgreen.svg?logo=open-source-initiative)  
[![Contact](https://img.shields.io/badge/follow-@macmade-blue.svg?logo=twitter&style=social)](https://twitter.com/macmade)
[![Sponsor](https://img.shields.io/badge/sponsor-macmade-pink.svg?logo=github-sponsors&style=social)](https://github.com/sponsors/macmade)

### About

A [Claude Code](https://docs.claude.com/en/docs/claude-code) plugin marketplace
by XS-Labs, bundling reusable commands and tooling for XS-Labs projects.

The marketplace ships two independent plugins so each can be installed at the
scope that fits it:

- **`xs`** — reusable commands, best installed **globally** so they are
  available in every project.
- **`xs-autoformat`** — an automatic Xcode Format hook, best installed
  **per-repository** so it only runs where you want it to.

### Installation

First, add the marketplace:

```
/plugin marketplace add macmade/claude-plugins
```

#### `xs` commands, globally

Install the commands plugin to your user settings (`~/.claude/settings.json`),
making the commands available across every project you open:

```
/plugin install xs@macmade
```

#### `xs-autoformat` hook, per-repository

To enable the formatting hook only in a given project — and share it with
everyone who clones the repo — commit a `.claude/settings.json` to that
project:

```json
{
  "extraKnownMarketplaces": {
    "macmade": {
      "source": {
        "source": "github",
        "repo": "macmade/claude-plugins"
      }
    }
  },
  "enabledPlugins": {
    "xs-autoformat@macmade": true
  }
}
```

Claude Code prompts collaborators to enable the plugin once they accept the
workspace trust dialog. Alternatively, install interactively scoped to the
current project:

```
/plugin install xs-autoformat@macmade --scope project
```

Both plugins are independent: install either one, or both, at whichever scope
you prefer.

### Plugins

#### `xs`

Reusable commands for XS-Labs projects.

| Command                   | Description                                                                                          |
| ------------------------- | ---------------------------------------------------------------------------------------------------- |
| `/review`                 | Perform a full, in-depth code review (whole repo, local changes, or a branch comparison), reporting the findings as Markdown, HTML, or inline. |
| `/plan`                   | Turn any source document (code review, roadmap, refactor notes, …) into a milestone-based plan.      |
| `/roadmap`                | Build a roadmap from points entered one at a time, or extend an existing one, as Markdown or HTML.   |
| `/implement`              | Implement a plan file milestone by milestone with TDD, pausing after each one for review and commit. |
| `/doc`                    | Document every type and member with SwiftDoc or HeaderDoc comments, choosing the language and files. |
| `/format`                 | Reformat repository sources with Xcode Format, choosing a configuration, file kinds, and git scope.  |
| `/commit-message`         | Generate a Conventional Commits message for the current changes (staged, unstaged, untracked), without committing. |
| `/release-notes`          | Summarize the current branch's changes versus main/master (and selected submodules) as application release notes, as Markdown, HTML, or inline. |

#### `xs-autoformat`

A `PostToolUse` hook that runs [Xcode Format](https://github.com/macmade/Xcode-Format)
on every Swift/C/C++/Objective-C file written or edited, using the
`XS-Labs (MIT)` configuration. It is a no-op on non-macOS systems, for
unsupported file types, or when the formatter is not installed.

License
-------

Project is released under the terms of the MIT License.

Repository Infos
----------------

    Owner:          Jean-David Gadina - XS-Labs
    Web:            www.xs-labs.com
    Blog:           www.noxeos.com
    Twitter:        @macmade
    GitHub:         github.com/macmade
    LinkedIn:       ch.linkedin.com/in/macmade/
    StackOverflow:  stackoverflow.com/users/182676/macmade
