#!/usr/bin/env bash
# claude-notify.sh — recolor the tmux window status entry based on Claude Code state.
#
# Wired to Claude Code hooks so a session shows its state in the status bar:
#   generating (UserPromptSubmit) -> amber  : Claude is working / generating
#   done       (Stop hook)        -> green  : Claude finished, your move
#   waiting    (Notification)     -> red    : blocked on a permission prompt
#                                              (idle-60s notifications stay green)
#
# Usage: claude-notify.sh <generating|done|waiting|reset>
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
  generating)
    # amber bg, black fg — Claude working / generating
    tmux set-window-option -t "$target" window-status-style       'fg=colour0,bg=colour214' 2>/dev/null || true
    tmux set-window-option -t "$target" window-status-current-style 'fg=colour0,bg=colour214' 2>/dev/null || true
    ;;
  done)
    # dark green bg, white fg — turn finished, your move (done or asked)
    tmux set-window-option -t "$target" window-status-style       'fg=colour15,bg=colour22' 2>/dev/null || true
    tmux set-window-option -t "$target" window-status-current-style 'fg=colour15,bg=colour22' 2>/dev/null || true
    ;;
  waiting)
    # Notification fires for two cases: a permission prompt, or ~60s idle.
    # Only a permission block is "act now" (red); idle just means the turn
    # already ended and you haven't replied -> treat as done (green).
    # The case is told apart by the hook's JSON payload on stdin. Skip the
    # read when stdin is a tty (manual run) so we don't block on cat.
    payload=""
    [ ! -t 0 ] && payload=$(cat 2>/dev/null || true)
    if printf '%s' "$payload" | grep -qi 'waiting for your input'; then
      # idle -> green (same as done)
      tmux set-window-option -t "$target" window-status-style       'fg=colour15,bg=colour22' 2>/dev/null || true
      tmux set-window-option -t "$target" window-status-current-style 'fg=colour15,bg=colour22' 2>/dev/null || true
    else
      # permission block -> red, act now
      tmux set-window-option -t "$target" window-status-style       'fg=colour15,bg=colour160' 2>/dev/null || true
      tmux set-window-option -t "$target" window-status-current-style 'fg=colour15,bg=colour160' 2>/dev/null || true
    fi
    ;;
  reset)
    # drop the per-window override -> fall back to tmux.conf defaults
    tmux set-window-option -u -t "$target" window-status-style         2>/dev/null || true
    tmux set-window-option -u -t "$target" window-status-current-style 2>/dev/null || true
    ;;
  *)
    echo "usage: $0 <generating|done|waiting|reset>" >&2
    exit 1
    ;;
esac

exit 0
