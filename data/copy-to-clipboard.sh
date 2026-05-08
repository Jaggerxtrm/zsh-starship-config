#!/usr/bin/env sh
# Portable tmux clipboard bridge.
# - Local Wayland/X11/macOS/WSL: use the native clipboard tool.
# - SSH/headless/VPS: fall back to tmux OSC52 via `load-buffer -w`, which
#   asks the *client terminal* to copy the selection.

set -u

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT HUP INT TERM
cat > "$tmp"

if command -v wl-copy >/dev/null 2>&1 \
  && [ -n "${WAYLAND_DISPLAY:-}" ] \
  && [ -n "${XDG_RUNTIME_DIR:-}" ]; then
  wl-copy < "$tmp" && exit 0
fi

if command -v xclip >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  xclip -selection clipboard < "$tmp" && exit 0
fi

if command -v xsel >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  xsel -i --clipboard < "$tmp" && exit 0
fi

if command -v pbcopy >/dev/null 2>&1; then
  pbcopy < "$tmp" && exit 0
fi

if command -v clip.exe >/dev/null 2>&1; then
  clip.exe < "$tmp" && exit 0
fi

# Remote/headless fallback. Requires the local terminal to allow OSC52.
if command -v tmux >/dev/null 2>&1 && [ -n "${TMUX:-}" ]; then
  tmux load-buffer -w "$tmp" && exit 0
fi

# Keep copy-mode from erroring loudly if no clipboard mechanism exists.
cat "$tmp" >/dev/null
exit 1
