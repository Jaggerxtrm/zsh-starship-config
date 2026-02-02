# Suggested Commands

## Installation & Updates
- `chmod +x install.sh`: Make the installer executable.
- `./install.sh`: Run the standard installation.
- `./install.sh --update` (or `./update.sh`): Update existing installation (Starship, plugins, config).
- `./install.sh --verbose`: Run installation with detailed output.

## Post-Installation
- `source ~/.zshrc`: Reload the Zsh configuration.
- `chsh -s $(which zsh)`: Change default shell to Zsh (if not done automatically).

## Verification
- `starship prompt`: Test Starship rendering.
- `echo $SHELL`: Verify current shell.
- `fc-list | grep "MesloLGS NF"`: Verify font installation.

## Project Maintenance
- `git pull`: Update the repository.
