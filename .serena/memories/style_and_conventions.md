# Style and Conventions

## Code Style
- **Bash**: 
  - Use `#!/bin/bash` shebang.
  - Prefer `[[ ]]` over `[ ]` for tests.
  - Use snake_case for variable names.
  - Include comments for complex logic.
- **TOML**: 
  - Standard TOML formatting for `starship.toml`.
  - Use comments to organize sections (e.g., `# Git branch`, `# Python`).

## Project Conventions
- **Prompt Symbol**: Use `>` (bold green for success, bold red for error).
- **Colors**: 
  - "Green Theme" for prompt structure.
  - "Tokyo Night" palette for highlights and specific elements.
- **Documentation**:
  - Keep `README.md`, `QUICK_START.md`, and `EXAMPLES.md` consistent with the configuration.
  - Use clear headings and code blocks.

## Workflow
- **Installation**: The `install.sh` script should be idempotent or handle existing installations gracefully (using backup/merge logic).
- **Updates**: Always use the `--update` flag or `update.sh` for existing setups to preserve user data where possible.
