# Project Overview: zsh-starship-config

## Purpose
A complete and portable setup for a modern Zsh configuration with the Starship prompt, optimized for developers. It automates the installation of Zsh, Oh My Zsh, plugins, Starship, and Nerd Fonts.

## Tech Stack
- **Shell Scripting**: Bash (`install.sh`, `update.sh`)
- **Shell**: Zsh, Oh My Zsh
- **Prompt**: Starship (configured via TOML)
- **Fonts**: Nerd Fonts (MesloLGS NF, JetBrainsMono, etc.)
- **npx**: Node.js entry point (`bin/cli.js`) for zero-clone installation

## Key Features
- **Automated installation script** (`install.sh`) supporting Fedora, RHEL, Ubuntu, Debian.
- **Smart update mechanism** with version tracking and diff-based configuration updates.
- **Two Starship themes**: Classic (`starship.toml`, Nerd Font icons, two-line) and Pure (`starship-pure.toml`, minimal Unicode symbols, right-prompt user@host).
- **Theme selection at install time** with ASCII preview of both options.
- **Automatic detection and handling** of WSL (Windows Subsystem for Linux).
- **Integration with Claude Code** status line with custom script.
- **Incremental configuration updates** that preserve user customizations.
- **Version tracking system** (`.config-version`, `~/.zsh-starship-config-version`).

## Project Structure
- `install.sh`: Main installation script with smart update mechanism.
- `update.sh`: Comprehensive update script with version checking and feature detection.
- `starship.toml`: Classic Starship theme (Nerd Font icons, two-line, full info).
- `starship-pure.toml`: Pure-inspired minimal theme (Unicode symbols, right prompt).
- `bin/cli.js`: npx entry point — spawns `install.sh` with inherited stdio.
- `package.json`: npm package definition for `npx` distribution.
- `.config-version`: Component version tracking file.
- `VERSION`: Release version file (currently 2.2.0).
- `data/`: Contains auxiliary files like `claude-statusline-starship.sh`.
- `scripts/`: Helper scripts (e.g., PowerShell for Windows fonts).
- `*.md`: Documentation (README, QUICK_START, EXAMPLES, CHANGELOG, etc.).
- `.serena/memories/`: Project documentation and memories.
