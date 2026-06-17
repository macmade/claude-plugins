#!/bin/bash
#
# Format the file just written/edited with Xcode Format, in place.
# Receives the PostToolUse hook payload as JSON on stdin.
#
# Errors are intentionally NOT silenced: on failure the formatter writes to
# stderr and exits non-zero, which Claude Code surfaces to the user without
# blocking. Every guard below exits 0 so non-applicable files are a no-op.

command -v jq >/dev/null 2>&1 || exit 0

f=$(jq -r '.tool_input.file_path // .tool_response.filePath // empty')
[ -n "$f" ] || exit 0
[ "$(uname -s)" = "Darwin" ] || exit 0

case "$f" in
  *.swift|*.c|*.h|*.m|*.mm|*.cpp|*.cc|*.cxx|*.hpp|*.hh) ;;
  *) exit 0 ;;
esac

fmt="/Applications/Xcode Format.app/Contents/MacOS/Xcode Format"
[ -x "$fmt" ] || exit 0

"$fmt" --config "XS-Labs (MIT)" "$f"
