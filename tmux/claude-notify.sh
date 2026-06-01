#!/usr/bin/env bash
# claude-notify.sh — recolor the tmux window status entry based on Claude Code state.
#
# Wired to Claude Code hooks so a backgrounded session shows in the status bar:
#   done    (Stop hook)          -> yellow  : Claude finished, awaiting you
#   waiting (Notification hook)  -> red      : Claude waiting for input/permission
#   reset   (UserPromptSubmit)   -> default  : you replied, Claude working
#
# Usage: claude-notify.sh <done|waiting|reset>
# Hooks run as a subprocess of the claude process, which lives in the tmux
# pane, so $TMUX / $TMUX_PANE are inherited. No-op when not inside tmux.

set -euo pipefail

state="${1:-}"

# Nothing to do outside tmux.
[ -z "${TMUX:-}" ] && exit 0
[ -z "${TMUX_PANE:-}" ] && exit 0

# Target the window owning this pane regardless of which window is current.
target="$TMUX_PANE"

case "$state" in
  done)
    # yellow bg, black fg — finished, needs your attention
    tmux set-window-option -t "$target" window-status-style       'fg=colour0,bg=colour220' 2>/dev/null || true
    tmux set-window-option -t "$target" window-status-current-style 'fg=colour0,bg=colour220' 2>/dev/null || true
    ;;
  waiting)
    # red bg, white fg — blocked on your input
    tmux set-window-option -t "$target" window-status-style       'fg=colour15,bg=colour160' 2>/dev/null || true
    tmux set-window-option -t "$target" window-status-current-style 'fg=colour15,bg=colour160' 2>/dev/null || true
    ;;
  reset)
    # drop the per-window override -> fall back to tmux.conf defaults
    tmux set-window-option -u -t "$target" window-status-style         2>/dev/null || true
    tmux set-window-option -u -t "$target" window-status-current-style 2>/dev/null || true
    ;;
  *)
    echo "usage: $0 <done|waiting|reset>" >&2
    exit 1
    ;;
esac

exit 0
