#!/usr/bin/env bash
# ============================================
# TMUX COLOR THEMES
# Contrast-Corrected, Graphite-Based
# ============================================

apply_theme() {
    local theme="$1"
    local session="$2"

    # session options (status bar)
    _set()  { tmux set-option -t "$session" "$@"; }

    # window options — applied at session level + all existing windows
    _setw() {
        # Session-level default (for new windows)
        tmux set-option -t "$session" -w "$@" 2>/dev/null || true
        # Apply immediately to all existing windows
        tmux list-windows -t "$session" -F '#{window_index}' 2>/dev/null | \
        while read -r idx; do
            tmux set-option -t "${session}:${idx}" -w "$@" 2>/dev/null || true
        done
    }

    # ============================================
    # GLOBAL TEXT PALETTE
    # ============================================
    # Dark themes: primary=#b8bcc0, strong=#c6cacf, muted=#8a8f94
    # Light themes: primary=#3f4347, strong=#2f3336, muted=#7a8086
    # Accents reserved for borders/highlights only

    case "$theme" in
        # ============================================
        # DARK THEMES
        # ============================================

        # --- BLACK / TOTAL BLACK (True terminal black) ---
        black|totalblack|total-black|trueblack|true-black)
            # Background: #000000
            _set  status-style               'fg=#d0d0d0,bg=#000000'
            _set  window-status-style        'fg=#808080,bg=#000000'
            _set  window-status-current-style 'fg=#ffffff,bg=#000000,bold'
            _setw window-style               'fg=#808080,bg=#000000'
            _setw window-active-style        'fg=#d0d0d0,bg=#000000'
            _setw pane-border-style          'fg=#202020,bg=#000000'
            _setw pane-active-border-style   'fg=#ffffff,bg=#000000'
            _set  message-style              'fg=#ffffff,bg=#101010'
            ;;

        # --- GRAPHITE (DEFAULT DARK - Neutral Accent) ---
        graphite|default|dark|"")
            # Background: #141414
            _set  status-style               'fg=#b8bcc0,bg=#141414'
            _set  window-status-style        'fg=#8a8f94,bg=#141414'
            _set  window-status-current-style 'fg=#c6cacf,bg=#141414,bold'
            _setw window-style               'fg=#8a8f94,bg=#141414'
            _setw window-active-style        'fg=#b8bcc0,bg=#141414'
            _setw pane-border-style          'fg=#303030,bg=#141414'
            _setw pane-active-border-style   'fg=#6f767d,bg=#141414'
            _set  message-style              'fg=#c6cacf,bg=#222222'
            ;;

        # --- COBALT (Accent: #5f87a8) ---
        cobalt)
            # Background: #1b2128
            _set  status-style               'fg=#b8bcc0,bg=#1b2128'
            _set  window-status-style        'fg=#8a8f94,bg=#1b2128'
            _set  window-status-current-style 'fg=#c6cacf,bg=#1b2128,bold'
            _setw window-style               'fg=#8a8f94,bg=#1b2128'
            _setw window-active-style        'fg=#b8bcc0,bg=#1b2128'
            _setw pane-border-style          'fg=#2a2a2a,bg=#1b2128'
            _setw pane-active-border-style   'fg=#5f87a8,bg=#1b2128'
            _set  message-style              'fg=#c6cacf,bg=#242424'
            ;;

        # --- GREEN / CODE (Dev/Coding - Background: #282c33) ---
        green|dev|coding|code)
            # Background: #282c33
            _set  status-style               'fg=#b8bcc0,bg=#282c33'
            _set  window-status-style        'fg=#8a8f94,bg=#282c33'
            _set  window-status-current-style 'fg=#c6cacf,bg=#282c33,bold'
            _setw window-style               'fg=#8a8f94,bg=#282c33'
            _setw window-active-style        'fg=#b8bcc0,bg=#282c33'
            _setw pane-border-style          'fg=#2a2a2a,bg=#282c33'
            _setw pane-active-border-style   'fg=#98c379,bg=#282c33'
            _set  message-style              'fg=#c6cacf,bg=#222222'
            ;;

        # --- BLUE (Research/Learning - xterm/iTerm-like Accent: #0000ff) ---
        blue|research|learning)
            # Background: neutral dark #141414; accent uses familiar terminal ANSI blue
            _set  status-style               'fg=#b8bcc0,bg=#141414'
            _set  window-status-style        'fg=#8a8f94,bg=#141414'
            _set  window-status-current-style 'fg=#c6cacf,bg=#141414,bold'
            _setw window-style               'fg=#8a8f94,bg=#141414'
            _setw window-active-style        'fg=#b8bcc0,bg=#141414'
            _setw pane-border-style          'fg=#303030,bg=#141414'
            _setw pane-active-border-style   'fg=#0000ff,bg=#141414'
            _set  message-style              'fg=#c6cacf,bg=#222222'
            ;;

        # --- PURPLE (Creative/Writing - xterm/iTerm-like Magenta Accent: #cd00cd) ---
        purple|creative|writing)
            # Background: neutral dark #141414; accent uses familiar terminal ANSI magenta
            _set  status-style               'fg=#b8bcc0,bg=#141414'
            _set  window-status-style        'fg=#8a8f94,bg=#141414'
            _set  window-status-current-style 'fg=#c6cacf,bg=#141414,bold'
            _setw window-style               'fg=#8a8f94,bg=#141414'
            _setw window-active-style        'fg=#b8bcc0,bg=#141414'
            _setw pane-border-style          'fg=#303030,bg=#141414'
            _setw pane-active-border-style   'fg=#cd00cd,bg=#141414'
            _set  message-style              'fg=#c6cacf,bg=#222222'
            ;;

        # --- ORANGE (Testing/Debugging - Accent: #d7a65f) ---
        orange|test|debug)
            # Background: #221b16
            _set  status-style               'fg=#b8bcc0,bg=#221b16'
            _set  window-status-style        'fg=#8a8f94,bg=#221b16'
            _set  window-status-current-style 'fg=#c6cacf,bg=#221b16,bold'
            _setw window-style               'fg=#8a8f94,bg=#221b16'
            _setw window-active-style        'fg=#b8bcc0,bg=#221b16'
            _setw pane-border-style          'fg=#2a2a2a,bg=#221b16'
            _setw pane-active-border-style   'fg=#d7a65f,bg=#221b16'
            _set  message-style              'fg=#c6cacf,bg=#262626'
            ;;

        # --- RED (Production/Urgent - xterm/iTerm-like Accent: #cd0000) ---
        red|prod|urgent)
            # Background: neutral dark #141414; accent uses familiar terminal ANSI red
            _set  status-style               'fg=#b8bcc0,bg=#141414'
            _set  window-status-style        'fg=#8a8f94,bg=#141414'
            _set  window-status-current-style 'fg=#c6cacf,bg=#141414,bold'
            _setw window-style               'fg=#8a8f94,bg=#141414'
            _setw window-active-style        'fg=#b8bcc0,bg=#141414'
            _setw pane-border-style          'fg=#303030,bg=#141414'
            _setw pane-active-border-style   'fg=#cd0000,bg=#141414'
            _set  message-style              'fg=#c6cacf,bg=#222222'
            ;;

        # --- NORD (Accent: #88c0d0) ---
        nord)
            # Background: #1f252d
            _set  status-style               'fg=#b8bcc0,bg=#1f252d'
            _set  window-status-style        'fg=#8a8f94,bg=#1f252d'
            _set  window-status-current-style 'fg=#c6cacf,bg=#1f252d,bold'
            _setw window-style               'fg=#8a8f94,bg=#1f252d'
            _setw window-active-style        'fg=#b8bcc0,bg=#1f252d'
            _setw pane-border-style          'fg=#2a2a2a,bg=#1f252d'
            _setw pane-active-border-style   'fg=#88c0d0,bg=#1f252d'
            _set  message-style              'fg=#c6cacf,bg=#262626'
            ;;

        # --- EVERFOREST (Accent: #a7c080) ---
        everforest|forest)
            # Background: #232a2e
            _set  status-style               'fg=#b8bcc0,bg=#232a2e'
            _set  window-status-style        'fg=#8a8f94,bg=#232a2e'
            _set  window-status-current-style 'fg=#c6cacf,bg=#232a2e,bold'
            _setw window-style               'fg=#8a8f94,bg=#232a2e'
            _setw window-active-style        'fg=#b8bcc0,bg=#232a2e'
            _setw pane-border-style          'fg=#2a2a2a,bg=#232a2e'
            _setw pane-active-border-style   'fg=#a7c080,bg=#232a2e'
            _set  message-style              'fg=#c6cacf,bg=#282828'
            ;;

        # --- GRUVBOX (Accent: #fabd2f) ---
        gruvbox)
            # Background: #202020
            _set  status-style               'fg=#b8bcc0,bg=#202020'
            _set  window-status-style        'fg=#8a8f94,bg=#202020'
            _set  window-status-current-style 'fg=#c6cacf,bg=#202020,bold'
            _setw window-style               'fg=#8a8f94,bg=#202020'
            _setw window-active-style        'fg=#b8bcc0,bg=#202020'
            _setw pane-border-style          'fg=#2a2a2a,bg=#202020'
            _setw pane-active-border-style   'fg=#fabd2f,bg=#202020'
            _set  message-style              'fg=#c6cacf,bg=#242424'
            ;;

        # ============================================
        # LIGHT THEMES
        # ============================================

        # --- PAPER (DEFAULT LIGHT - Neutral Accent) ---
        paper|light)
            # Background: #f3f3f1
            _set  status-style               'fg=#3f4347,bg=#f3f3f1'
            _set  window-status-style        'fg=#7a8086,bg=#f3f3f1'
            _set  window-status-current-style 'fg=#2f3336,bg=#f3f3f1,bold'
            _setw window-style               'fg=#7a8086,bg=#f3f3f1'
            _setw window-active-style        'fg=#3f4347,bg=#f3f3f1'
            _setw pane-border-style          'fg=#d2d6da,bg=#f3f3f1'
            _setw pane-active-border-style   'fg=#8a9096,bg=#f3f3f1'
            _set  message-style              'fg=#2f3336,bg=#e6e6e2'
            ;;

        # --- LCOBALT (Accent: #5f87a8) ---
        lcobalt)
            # Background: #eef3f7
            _set  status-style               'fg=#3f4347,bg=#eef3f7'
            _set  window-status-style        'fg=#7a8086,bg=#eef3f7'
            _set  window-status-current-style 'fg=#2f3336,bg=#eef3f7,bold'
            _setw window-style               'fg=#7a8086,bg=#eef3f7'
            _setw window-active-style        'fg=#3f4347,bg=#eef3f7'
            _setw pane-border-style          'fg=#d2d6da,bg=#eef3f7'
            _setw pane-active-border-style   'fg=#5f87a8,bg=#eef3f7'
            _set  message-style              'fg=#2f3336,bg=#e2e8ec'
            ;;

        # --- LGREEN (Accent: #98c379) ---
        lgreen)
            # Background: #eef7ea
            _set  status-style               'fg=#3f4347,bg=#eef7ea'
            _set  window-status-style        'fg=#7a8086,bg=#eef7ea'
            _set  window-status-current-style 'fg=#2f3336,bg=#eef7ea,bold'
            _setw window-style               'fg=#7a8086,bg=#eef7ea'
            _setw window-active-style        'fg=#3f4347,bg=#eef7ea'
            _setw pane-border-style          'fg=#d2d6da,bg=#eef7ea'
            _setw pane-active-border-style   'fg=#98c379,bg=#eef7ea'
            _set  message-style              'fg=#2f3336,bg=#e4ece6'
            ;;

        # --- LBLUE (xterm/iTerm-like Accent: #0000ff) ---
        lblue)
            # Background: neutral paper #f3f3f1; accent uses familiar terminal ANSI blue
            _set  status-style               'fg=#3f4347,bg=#f3f3f1'
            _set  window-status-style        'fg=#7a8086,bg=#f3f3f1'
            _set  window-status-current-style 'fg=#2f3336,bg=#f3f3f1,bold'
            _setw window-style               'fg=#7a8086,bg=#f3f3f1'
            _setw window-active-style        'fg=#3f4347,bg=#f3f3f1'
            _setw pane-border-style          'fg=#d2d6da,bg=#f3f3f1'
            _setw pane-active-border-style   'fg=#0000ff,bg=#f3f3f1'
            _set  message-style              'fg=#2f3336,bg=#e6e6e2'
            ;;

        # --- LPURPLE (xterm/iTerm-like Magenta Accent: #cd00cd) ---
        lpurple)
            # Background: neutral paper #f3f3f1; accent uses familiar terminal ANSI magenta
            _set  status-style               'fg=#3f4347,bg=#f3f3f1'
            _set  window-status-style        'fg=#7a8086,bg=#f3f3f1'
            _set  window-status-current-style 'fg=#2f3336,bg=#f3f3f1,bold'
            _setw window-style               'fg=#7a8086,bg=#f3f3f1'
            _setw window-active-style        'fg=#3f4347,bg=#f3f3f1'
            _setw pane-border-style          'fg=#d2d6da,bg=#f3f3f1'
            _setw pane-active-border-style   'fg=#cd00cd,bg=#f3f3f1'
            _set  message-style              'fg=#2f3336,bg=#e6e6e2'
            ;;

        # --- LORANGE (Accent: #d7a65f) ---
        lorange)
            # Background: #fbf2e7
            _set  status-style               'fg=#3f4347,bg=#fbf2e7'
            _set  window-status-style        'fg=#7a8086,bg=#fbf2e7'
            _set  window-status-current-style 'fg=#2f3336,bg=#fbf2e7,bold'
            _setw window-style               'fg=#7a8086,bg=#fbf2e7'
            _setw window-active-style        'fg=#3f4347,bg=#fbf2e7'
            _setw pane-border-style          'fg=#d2d6da,bg=#fbf2e7'
            _setw pane-active-border-style   'fg=#d7a65f,bg=#fbf2e7'
            _set  message-style              'fg=#2f3336,bg=#f2e8dc'
            ;;

        # --- LRED (xterm/iTerm-like Accent: #cd0000) ---
        lred)
            # Background: neutral paper #f3f3f1; accent uses familiar terminal ANSI red
            _set  status-style               'fg=#3f4347,bg=#f3f3f1'
            _set  window-status-style        'fg=#7a8086,bg=#f3f3f1'
            _set  window-status-current-style 'fg=#2f3336,bg=#f3f3f1,bold'
            _setw window-style               'fg=#7a8086,bg=#f3f3f1'
            _setw window-active-style        'fg=#3f4347,bg=#f3f3f1'
            _setw pane-border-style          'fg=#d2d6da,bg=#f3f3f1'
            _setw pane-active-border-style   'fg=#cd0000,bg=#f3f3f1'
            _set  message-style              'fg=#2f3336,bg=#e6e6e2'
            ;;

        # --- LNORD (Accent: #88c0d0) ---
        lnord)
            # Background: #eef3f5
            _set  status-style               'fg=#3f4347,bg=#eef3f5'
            _set  window-status-style        'fg=#7a8086,bg=#eef3f5'
            _set  window-status-current-style 'fg=#2f3336,bg=#eef3f5,bold'
            _setw window-style               'fg=#7a8086,bg=#eef3f5'
            _setw window-active-style        'fg=#3f4347,bg=#eef3f5'
            _setw pane-border-style          'fg=#d2d6da,bg=#eef3f5'
            _setw pane-active-border-style   'fg=#88c0d0,bg=#eef3f5'
            _set  message-style              'fg=#2f3336,bg=#e4eaec'
            ;;

        # --- LEVERFOREST (Accent: #a7c080) ---
        leverforest)
            # Background: #f1f4ed
            _set  status-style               'fg=#3f4347,bg=#f1f4ed'
            _set  window-status-style        'fg=#7a8086,bg=#f1f4ed'
            _set  window-status-current-style 'fg=#2f3336,bg=#f1f4ed,bold'
            _setw window-style               'fg=#7a8086,bg=#f1f4ed'
            _setw window-active-style        'fg=#3f4347,bg=#f1f4ed'
            _setw pane-border-style          'fg=#d2d6da,bg=#f1f4ed'
            _setw pane-active-border-style   'fg=#a7c080,bg=#f1f4ed'
            _set  message-style              'fg=#2f3336,bg=#e7ece2'
            ;;

        # --- LGRUVBOX (Accent: #fabd2f) ---
        lgruvbox)
            # Background: #f6f1e4
            _set  status-style               'fg=#3f4347,bg=#f6f1e4'
            _set  window-status-style        'fg=#7a8086,bg=#f6f1e4'
            _set  window-status-current-style 'fg=#2f3336,bg=#f6f1e4,bold'
            _setw window-style               'fg=#7a8086,bg=#f6f1e4'
            _setw window-active-style        'fg=#3f4347,bg=#f6f1e4'
            _setw pane-border-style          'fg=#d2d6da,bg=#f6f1e4'
            _setw pane-active-border-style   'fg=#fabd2f,bg=#f6f1e4'
            _set  message-style              'fg=#2f3336,bg=#eee6d3'
            ;;

        *)
            echo "Unknown theme: $theme"
            echo ""
            echo "Dark themes:"
            echo "  black, graphite (default), cobalt, green, blue"
            echo "  purple, orange, red, nord, everforest, gruvbox"
            echo ""
            echo "Light themes:"
            echo "  paper (default light), lcobalt, lgreen, lblue"
            echo "  lpurple, lorange, lred, lnord, leverforest, lgruvbox"
            return 1
            ;;
    esac

    # Refresh all clients to apply changes immediately
    tmux refresh-client -t "$session" 2>/dev/null || true

    echo "Applied '$theme' theme to session '$session'"
}

# Run standalone: bash themes.sh <theme> [session]
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    SESSION="${2:-$(tmux display-message -p '#S' 2>/dev/null)}"
    apply_theme "$1" "$SESSION"
fi