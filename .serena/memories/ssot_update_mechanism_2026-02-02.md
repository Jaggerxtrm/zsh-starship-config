---
category: ssot
domain: configuration-management
scope: update-mechanism
version: 1.1.2
created: 2026-02-02
updated: 2026-02-02
tags: [update, version-tracking, diff-based, configuration, robustness, schema, path-priority]
---

# SSOT: Update Mechanism

## Overview

The update mechanism ensures that existing users can safely receive new features and configuration updates without losing their customizations. Implemented in v2.1.0 as a complete rewrite of the update system, and refined in v2.1.4 for environment reliability.

## Key Reliability Improvements

### PATH Priority (v2.1.4)
To ensure that local tools like `eza` are correctly detected during shell initialization, the `PATH` export for `~/.local/bin` is now placed at the very top of the `.zshrc` file. This prevents a race condition where aliases were not being defined because the tool was not yet in the `PATH`.

## Architecture

### Components

```
┌─────────────────────────────────────────────────────────────┐
│                     Update System                            │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────┐      ┌──────────────────┐            │
│  │ Version Tracking │      │  update.sh       │            │
│  │                  │      │  (User-facing)   │            │
│  │ .config-version  │◄─────┤  • Git check     │            │
│  │ VERSION          │      │  • Version diff  │            │
│  │ ~/.zsh-...-vers. │      │  • Feature check │            │
│  └──────────────────┘      │  • Source guard  │            │
│                            └────────┬─────────┘            │
│                                      │                       │
│                                      ▼                       │
│  ┌──────────────────────────────────────────────┐          │
│  │  install.sh --update                         │          │
│  │  (Core Update Logic)                         │          │
│  ├──────────────────────────────────────────────┤          │
│  │  • Anti-Sourcing Guard                       │          │
│  │  • WSL Interop Guards (cmd, powershell)      │          │
│  │  • apply_starship_config()                   │          │
│  │    ├─ diff check                             │          │
│  │    ├─ backup creation                        │          │
│  │    └─ selective update                       │          │
│  │                                               │          │
│  │  • merge_zshrc_config()                      │          │
│  │    ├─ plugin detection                       │          │
│  │    ├─ specific alias checks (lsga,lsg3,lsgm) │          │
│  │    ├─ Bun config check                       │          │
│  │    ├─ dotfiles alias check                   │          │
│  │    └─ Claude Code env vars check             │          │
│  │                                               │          │
│  │  • show_update_summary()                     │          │
│  │    └─ report changes                         │          │
│  └──────────────────────────────────────────────┘          │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Robustness Features (v2.1.1)

### Anti-Sourcing Guard
To prevent accidental terminal closures, both `update.sh` and `install.sh` include a guard that prevents the script from being executed via `source` or `.`.
```bash
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo "Error: This script should not be sourced."
    return 1 2>/dev/null || exit 1
fi
```

### WSL Interop Verification
Before calling Windows-specific binaries (`cmd.exe`, `powershell.exe`) from WSL, the scripts now verify their existence using `command -v`. This prevents the script from terminating abruptly if Windows Interop is disabled.

## Version Tracking

### Files

1. **`.config-version`** (repository)
   ```bash
   STARSHIP_CONFIG_VERSION=2.1.0
   ZSHRC_TEMPLATE_VERSION=2.1.0

   # Version History:
   # 2.1.0 (2026-02-02) - Added custom aliases, Bun config
   ```

2. **`VERSION`** (repository)
   ```
   2.1.0
   ```

3. **`~/.zsh-starship-config-version`** (user system)
   - Created/updated after each install
   - Enables version comparison

### Version Comparison Logic

```bash
# In update.sh
INSTALLED_VERSION=$(cat ~/.zsh-starship-config-version)
REPO_VERSION=$(cat VERSION)

if [ "$INSTALLED_VERSION" != "$REPO_VERSION" ]; then
    echo "Update available: v$INSTALLED_VERSION → v$REPO_VERSION"
fi
```

## Smart Update: starship.toml

### Problem (Before v2.1.0)
```bash
# Always overwrote, no backup, no user choice
cp starship.toml ~/.config/starship.toml
```

### Solution (v2.1.0+)
```bash
apply_starship_config() {
    # 1. Check if files differ
    if ! diff -q "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"; then

        # 2. Create backup
        BACKUP="$HOME/.config/starship.toml.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$HOME/.config/starship.toml" "$BACKUP"

        # 3. User choice (normal mode) or auto-update (--update mode)
        if [ "$UPDATE_MODE" = true ]; then
            cp "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"
            STARSHIP_UPDATED=true
        else
            read -p "Update starship.toml? (s/N) "
            # ... handle user response
        fi
    else
        STARSHIP_UNCHANGED=true
    fi
}
```

### Benefits
- ✅ No data loss (automatic backups)
- ✅ User control in normal mode
- ✅ Efficient (only updates if changed)
- ✅ Trackable (status variables)

## Smart Update: .zshrc

### Problem (Before v2.1.0)
```bash
# Only checked: "does ANY eza alias exist?"
if ! grep -q "alias.*eza" "$ZSHRC"; then
    # Add ALL eza aliases
fi
# Result: New aliases (lsga, lsg3, lsgm) never added
```

### Solution (v2.1.0+)
```bash
merge_zshrc_config() {
    # Check EACH feature individually

    # 1. Specific alias detection
    if ! grep -q "alias lsga=" "$ZSHRC"; then
        # Add only lsga
    fi

    if ! grep -q "alias lsg3=" "$ZSHRC"; then
        # Add only lsg3
    fi

    # 2. Configuration blocks
    if ! grep -q "BUN_INSTALL" "$ZSHRC"; then
        # Add Bun config
    fi

    if ! grep -q "alias config=" "$ZSHRC"; then
        # Add dotfiles alias
    fi

    if ! grep -q "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC" "$ZSHRC"; then
        # Add Claude Code env vars
    fi
}
```

### Tracked Features (v2.1.0)

| Feature | Detection Pattern | Added When |
|---------|------------------|------------|
| lsga alias | `alias lsga=` | v2.1.0 |
| lsg3 alias | `alias lsg3=` | v2.1.0 |
| lsgm alias | `alias lsgm=` | v2.1.0 |
| Bun config | `BUN_INSTALL` | v2.1.0 |
| Dotfiles alias | `alias config=` | v2.1.0 |
| Claude env vars | `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` | v2.1.0 |

## update.sh Script

### Workflow

```
1. Git Repository Check
   ├─ Fetch latest changes
   ├─ Compare local vs remote
   └─ Offer to pull if updates available

2. Version Information
   ├─ Load .config-version (component versions)
   ├─ Load VERSION (release version)
   └─ Load ~/.zsh-starship-config-version (installed)

3. Configuration Check
   ├─ Check starship.toml (diff -q)
   └─ Check .zshrc for missing features
       ├─ lsga, lsg3, lsgm aliases
       ├─ Bun configuration
       ├─ Dotfiles alias
       └─ Claude Code env vars

4. Report to User
   ├─ List what's different
   ├─ List missing features
   └─ Ask for confirmation

5. Execute Update
   ├─ Run ./install.sh --update --verbose
   └─ Save new version to ~/.zsh-starship-config-version

6. Post-Update Instructions
   └─ Show next steps (source ~/.zshrc, etc.)
```

### Output Example

```
================================================
🔄 Zsh Starship Config - Smart Update
================================================

📥 Checking for repository updates...
✓ Repository already up to date

================================================
Version Information
================================================
Release: v2.1.0
Config Version: v2.1.0
Installed Version: v2.0.0
⚠️  Update available: v2.0.0 → v2.1.0

================================================
Checking Configuration Files
================================================
⚠️  starship.toml: Differs from repository
⚠️  .zshrc: Missing new features:
  • lsga alias (eza tree with git)
  • lsg3 alias (eza 3-level tree)
  • lsgm alias (git status -s)
  • Bun configuration
  • Dotfiles git alias
  • Claude Code env vars

================================================
Update Options
================================================
Proceed with update? (s/N)
```

## Update Summary Report

### Function: `show_update_summary()`

Displays after update completes:

```
===================================
📋 Update Summary
===================================
starship.toml: ✅ Updated
.zshrc: ✅ Updated with new configurations
  New additions may include:
    • Custom eza aliases (lsga, lsg3, lsgm)
    • Bun configuration
    • Dotfiles git alias (config)
    • Claude Code environment variables
===================================
```

## Update Tracking Variables

### Global Variables (install.sh)

```bash
# Set at start
STARSHIP_UPDATED=false
STARSHIP_SKIPPED=false
STARSHIP_UNCHANGED=false
ZSHRC_UPDATED=false
ZSHRC_SKIPPED=false
ZSHRC_UNCHANGED=false

# Updated by functions
apply_starship_config()   # Sets STARSHIP_*
merge_zshrc_config()      # Sets ZSHRC_*
show_update_summary()     # Reads all variables
```

## Adding New Features

When adding new .zshrc features in future versions:

1. **Add to template** (`create_new_zshrc()` function)
2. **Add detection** to `merge_zshrc_config()`:
   ```bash
   if ! grep -q "alias my_new_alias=" "$ZSHRC"; then
       echo "  + Aggiunta alias: my_new_alias"
       # Add the alias...
       CHANGES_MADE=true
   fi
   ```
3. **Add to update.sh** feature checks:
   ```bash
   if ! grep -q "alias my_new_alias=" "$HOME/.zshrc"; then
       MISSING_FEATURES="${MISSING_FEATURES}  • my_new_alias\n"
   fi
   ```
4. **Update `.config-version`** with new version
5. **Update `VERSION`** file

## Testing

### Verify Syntax
```bash
bash -n install.sh
bash -n update.sh
```

### Test Update Path
```bash
# Simulate old version
echo "2.0.0" > ~/.zsh-starship-config-version

# Run update
./update.sh

# Should show:
# - Version: 2.0.0 → 2.1.0
# - Missing features list
# - Update confirmation
```

## Files Changed

### New Files (v2.1.0)
- `.config-version` - Component version tracking

### Modified Files (v2.1.0)
- `install.sh` (+175 lines) - Smart diff updates + summary
- `update.sh` (+177 lines) - Complete rewrite
- `VERSION` - 1.7.0 → 2.1.0

## Related Issues

- GitHub Issue #1: Fixed directory handling bugs
- Commit 88a0496: Bug fixes + system customizations sync
- Commit df4e699: Update mechanism implementation

## References

- install.sh lines 10-16: Global variables
- install.sh lines 503-553: `apply_starship_config()`
- install.sh lines 703-807: `merge_zshrc_config()`
- install.sh lines 989-1034: `show_update_summary()`
- update.sh: Complete smart update script
