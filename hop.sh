#!/bin/sh
# Hop: focus the agent waiting on you — blocked first, then done, newest change first.
# Skips the agent you're already on. Nothing waiting → just raises iTerm.
# `hop.sh --pick` reads `herdr agent list` JSON on stdin and prints the target pane (used by test.sh).
h="${HERDR_BIN_PATH:-$HOME/.local/bin/herdr}"
pick() {
  /usr/bin/jq -r '[.result.agents[] | select((.focused | not) and (.agent_status == "blocked" or .agent_status == "done"))]
    | sort_by((if .agent_status == "blocked" then 0 else 1 end), -.state_change_seq) | .[0].pane_id // empty'
}
[ "$1" = --pick ] && { pick; exit; }
target=$("$h" agent list | pick)
[ -n "$target" ] && {
  "$h" agent focus "$target" >/dev/null
  # ctrl+end = Claude Code's scroll:bottom. The "Jump to bottom" viewport is Claude Code's own, so herdr's
  # pane.scroll can't reach it, and herdr send-keys doesn't know `end`, so send the raw escape sequence.
  "$h" pane send-text "$target" "$(printf '\033[1;5F')" >/dev/null
}
open -a iTerm
