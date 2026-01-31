#!/bin/bash
# Starship-inspired status line for Claude Code

# Read JSON input
input=$(cat)

# Extract current directory from input
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Get username
user=$(whoami)

# Get git info if in a git repo
git_info=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "detached")
    
    # Check for modifications
    if ! git -C "$cwd" diff-index --quiet HEAD -- 2>/dev/null; then
        status_icon=" "  # Modified icon
        git_info=$(printf '\033[35m\uf1d3 \ue0a0 %s\033[0m \033[31m%s\033[0m ' "$branch" "$status_icon")
    else
        git_info=$(printf '\033[35m\uf1d3 \ue0a0 %s\033[0m ' "$branch")
    fi
fi

# Get Python virtualenv info
python_info=""
if [ -n "$VIRTUAL_ENV" ]; then
    venv_name=$(basename "$VIRTUAL_ENV")
    python_info=$(printf '\033[33m\ue73c (%s) \033[0m' "$venv_name")
fi

# Format directory path (replace home with ~)
display_dir="${cwd/#$HOME/\~}"

# Output status line
printf '\uf17c %s %s %s%s' "$user" "$display_dir" "$git_info" "$python_info"
