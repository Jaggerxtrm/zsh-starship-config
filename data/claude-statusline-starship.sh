#!/bin/bash
#
# claude-statusline-starship.sh
# Statusline command that mirrors Starship prompt configuration
#
# Format: model [usage%] username@hostname directory git_branch git_status python_venv
# Based on: ~/.config/starship.toml
#
# Requires: jq (for JSON parsing)

# Read JSON input from stdin
input=$(cat)

# Extract model display name from JSON (cyan)
model_display=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')

# Extract token usage percentage
token_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$token_percentage" ]; then
  token_display=$(printf "[%.0f%%]" "$token_percentage")
  model_display="$model_display $token_display"
fi

# Extract current directory from JSON
dir=$(echo "$input" | jq -r '.workspace.current_dir')

# Username (white)
user=$(whoami)

# Hostname (bold green)
host=$(hostname -s)

# Directory (white, truncated to repo when inside git)
repo_root=$(cd "$dir" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null)
if [ -n "$repo_root" ]; then
  rel_path=$(realpath --relative-to="$repo_root" "$dir" 2>/dev/null || echo ".")
  if [ "$rel_path" = "." ]; then
    display_dir=$(basename "$repo_root")
  else
    display_dir="$(basename "$repo_root")/$rel_path"
  fi
else
  display_dir=$(echo "$dir" | sed "s|^$HOME|home|")
fi

# Git branch and status (green)
git_info=""
git_status_icon=""
if cd "$dir" 2>/dev/null && git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -c core.useBuiltinFSMonitor=false branch --show-current 2>/dev/null || echo "HEAD")
  # Git icon: U+F09B (nerd font)
  git_icon=$(printf '\uf09b')
  git_info=" $git_icon $branch"

  # Check for modified files
  status=$(git -c core.useBuiltinFSMonitor=false status --porcelain 2>/dev/null)
  if [ -n "$status" ]; then
    # Modified icon: U+F040 (nerd font)
    mod_icon=$(printf '\uf040')
    git_status_icon=" $mod_icon"
  fi
fi

# Python virtual environment (yellow)
venv=""
if [ -n "$VIRTUAL_ENV" ]; then
  # Python icon: U+E73C (nerd font)
  py_icon=$(printf '\ue73c')
  venv=" $py_icon ($(basename "$VIRTUAL_ENV"))"
fi

# Output with ANSI colors matching Starship theme
# Colors: cyan(36), white(37), bold green(1;32), green(32), yellow(33)
printf '\033[36m%s\033[0m \033[37m%s\033[0m@\033[1;32m%s\033[0m \033[37m%s\033[0m\033[32m%s%s\033[0m\033[33m%s\033[0m' \
  "$model_display" "$user" "$host" "$display_dir" "$git_info" "$git_status_icon" "$venv"
