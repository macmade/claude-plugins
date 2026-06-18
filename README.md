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

### Installation

#### Globally, for all your projects

Add the marketplace, then install the `xs` plugin:

```
/plugin marketplace add macmade/claude-plugins
/plugin install xs@macmade
```

This installs to your user settings (`~/.claude/settings.json`), making the
plugin available across every project you open.

#### For a single project or team repository

To enable the plugin only in a given project — and share it with everyone who
clones the repo — commit a `.claude/settings.json` to that project:

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
    "xs@macmade": true
  }
}
```

Claude Code prompts collaborators to enable the plugin once they accept the
workspace trust dialog. Alternatively, install interactively scoped to the
current project:

```
/plugin install xs@macmade --scope project
```

### Plugins

#### `xs`

Reusable commands and tooling for XS-Labs projects.

**Commands**

| Command                   | Description                                                                                          |
| ------------------------- | ---------------------------------------------------------------------------------------------------- |
| `/review`                 | Perform a full, in-depth code review of the project, writing the findings to Markdown or HTML.       |
| `/plan`                   | Turn any source document (code review, roadmap, refactor notes, …) into a milestone-based plan.      |
| `/implement`              | Implement a plan file milestone by milestone with TDD, pausing after each one for review and commit. |
| `/doc`                    | Document every type and member with SwiftDoc or HeaderDoc comments, choosing the language and files. |
| `/format`                 | Reformat repository sources with Xcode Format, choosing a configuration, file kinds, and git scope.  |

**Hooks**

A `PostToolUse` hook runs [Xcode Format](https://github.com/macmade/Xcode-Format)
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
