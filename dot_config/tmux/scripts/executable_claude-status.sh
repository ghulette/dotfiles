#!/usr/bin/env bash
# Flag the tmux window running Claude Code so the status bar can show it.
# Called from Claude Code hooks (see ~/.claude/settings.json):
#   claude-status.sh done       Claude finished its turn
#   claude-status.sh attention  Claude needs input (permission prompt, idle)
#   claude-status.sh            clear the flag
# tmux.conf shows the flag on inactive windows and clears it on focus.
# Always exits 0 so a tmux hiccup never blocks Claude.

[ -n "$TMUX_PANE" ] || exit 0

if [ -z "$1" ]; then
    tmux set -wu -t "$TMUX_PANE" @claude 2>/dev/null
# Skip if you're already looking at this window
elif [ "$(tmux display -p -t "$TMUX_PANE" '#{&&:#{window_active},#{session_attached}}' 2>/dev/null)" != 1 ]; then
    tmux set -w -t "$TMUX_PANE" @claude "$1" 2>/dev/null
fi
exit 0
