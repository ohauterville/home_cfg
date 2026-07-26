#!/usr/bin/env bash
set -e

export PATH="$HOME/.fzf/bin:$PATH"

result=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | \
  fzf --print-query \
      --prompt="Session > " \
      --header="Enter session = switch | Type non existing session + Enter = create new-session" \
      --preview 'tmux list-panes -t {} -F "#{window_index}.#{pane_index} #{pane_current_command}" 2>/dev/null; \
                 echo "---"; \
                 tmux capture-pane -ep -t {}.0 2>/dev/null | tail -n 40' \
      --preview-window 'right:60%' \
  | tail -n 1)

query=$(echo "$result" | head -n 1)
selection=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | \
  fzf --filter="$query" 2>/dev/null | head -n 1)

target="${selection:-$query}"

[ -z "$target" ] && exit 0

if tmux has-session -t "$target" 2>/dev/null; then
  tmux switch-client -t "$target"
else
  tmux new-session -d -s "$target"
  tmux switch-client -t "$target"
fi