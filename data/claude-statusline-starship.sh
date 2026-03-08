#!/bin/bash
#
# claude-statusline-starship.sh
# Statusline per Claude Code che rispecchia ~/.config/starship.toml
#
# Stile: neutral, professionale, adattivo ai temi tmux
# Format: model [xx%] hostname dir branch (status) (venv)
#
# Richiede: jq

input=$(cat)

# Model + token usage
model_display=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')
token_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$token_percentage" ]; then
  token_display=$(printf "[%.0f%%]" "$token_percentage")
  model_display="$model_display $token_display"
fi

dir=$(echo "$input" | jq -r '.workspace.current_dir')
user=$(whoami)
host=$(hostname -s)

# Directory — basename del repo se dentro git, altrimenti basename del path
repo_root=$(cd "$dir" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null)
if [ -n "$repo_root" ]; then
  rel_path=$(realpath --relative-to="$repo_root" "$dir" 2>/dev/null || echo ".")
  if [ "$rel_path" = "." ]; then
    display_dir=$(basename "$repo_root")
  else
    display_dir="$(basename "$repo_root")/$rel_path"
  fi
else
  display_dir=$(echo "$dir" | sed "s|^$HOME|~|")
fi

# Git branch e status
git_branch=""
git_status_str=""
if cd "$dir" 2>/dev/null && git rev-parse --git-dir >/dev/null 2>&1; then
  git_branch=$(git -c core.useBuiltinFSMonitor=false branch --show-current 2>/dev/null || echo "HEAD")

  porcelain=$(git -c core.useBuiltinFSMonitor=false --no-optional-locks status --porcelain 2>/dev/null)
  modified=$(echo "$porcelain" | grep -c "^ M\|^AM\|^MM" 2>/dev/null || echo 0)
  staged=$(echo "$porcelain" | grep -c "^A \|^M " 2>/dev/null || echo 0)
  deleted=$(echo "$porcelain" | grep -c "^ D\|^D " 2>/dev/null || echo 0)

  st=""
  [ "$modified" -gt 0 ] && st="${st}*"
  [ "$staged" -gt 0 ]   && st="${st}+"
  [ "$deleted" -gt 0 ]  && st="${st}-"

  ahead_behind=$(git -c core.useBuiltinFSMonitor=false --no-optional-locks rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
  if [ -n "$ahead_behind" ]; then
    behind=$(echo "$ahead_behind" | awk '{print $1}')
    ahead=$(echo "$ahead_behind" | awk '{print $2}')
    if   [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then st="${st}↕"
    elif [ "$ahead" -gt 0 ];                         then st="${st}↑"
    elif [ "$behind" -gt 0 ];                        then st="${st}↓"
    fi
  fi

  [ -n "$st" ] && git_status_str="($st)"
fi

# Python venv
venv_str=""
[ -n "$VIRTUAL_ENV" ] && venv_str="($(basename "$VIRTUAL_ENV"))"

# ANSI — bold e dim ereditano fg del tema tmux corrente
BOLD=$'\033[1m'
DIM=$'\033[2m'
AMBER=$'\033[38;2;204;120;50m'
RESET=$'\033[0m'

# Build output
out=""
out+="${DIM}${model_display}${RESET}"
out+=" ${host}"
out+=" ${BOLD}${display_dir}${RESET}"

if [ -n "$git_branch" ]; then
  out+=" ${DIM}${git_branch}${RESET}"
  [ -n "$git_status_str" ] && out+=" ${DIM}${git_status_str}${RESET}"
fi

[ -n "$venv_str" ] && out+=" ${DIM}${venv_str}${RESET}"

printf '%s' "$out"
