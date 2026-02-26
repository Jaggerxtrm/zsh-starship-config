# NPM Package Info

## Overview
The project is configured for distribution via npm/npx.
- **Package Name**: `zsh-starship-config`
- **Entry Point**: `bin/cli.js` (Wrapper for `install.sh`)
- **Installation**: `npx zsh-starship-config`

## Implementation Details
- `bin/cli.js`: A Node.js script that spawns `install.sh`. It handles permissions (`chmod +x`) and passes arguments.
- `package.json`: configured with `bin` entry and `files` whitelist (`install.sh`, `data/`, `scripts/`, etc.).
- `install.sh`: Uses `SCRIPT_DIR` to locate resources relative to the package root.

## Maintenance
- When updating `install.sh` or other files, the npm package version should be bumped in `package.json` before publishing.
