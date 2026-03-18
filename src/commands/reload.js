'use strict';

const path = require('path');
const { execute } = require('../utils/system');
const { createLogger } = require('../utils/logger');

/**
 * Reload command handler
 */

/**
 * Reload tmux configuration
 */
async function reload(options = {}, scriptDir) {
  try {
    // Initialize logger
    const logger = createLogger({
      silent: false,
      verbose: options.verbose || false
    });

    logger.banner('RELOAD TMUX CONFIGURATION', 'cyan');

    // Check if tmux is running
    const tmuxCheck = execute('tmux info', { stdio: 'pipe' });

    if (!tmuxCheck.success && !tmuxCheck.stdout.includes('server running')) {
      logger.warning('Tmux is not running. Configuration will be reloaded when tmux starts.');
      logger.info('If tmux is running in a different terminal, run: tmux source-file ~/.tmux.conf');
      return { success: true, reloaded: false };
    }

    // Reload tmux configuration
    logger.section('Reloading tmux configuration');

    const reloadCmd = execute('tmux source-file ~/.tmux.conf', {
      stdio: 'pipe'
    });

    if (!reloadCmd.success) {
      throw new Error(`Failed to reload tmux configuration: ${reloadCmd.stderr}`);
    }

    logger.success('✓ Tmux configuration reloaded successfully');
    logger.info('New settings are now active in tmux');

    // Display verification
    logger.section('Verification');

    // Verify keybindings
    const verifyKeys = execute('tmux list-keys -T | rg "set-clipboard|@yank"', {
      stdio: 'pipe'
    });

    if (verifyKeys.success && verifyKeys.stdout.includes('set-clipboard')) {
      logger.success('✓ Clipboard settings verified');
    } else {
      logger.warning('⚠ Could not verify clipboard settings');
    }

    // Verify plugins
    const verifyPlugins = execute('tmux run-shell "ls ~/.tmux/plugins/tpm"', {
      stdio: 'pipe'
    });

    if (verifyPlugins.success && verifyPlugins.stdout.includes('tmux-yank')) {
      logger.success('✓ tmux-yank plugin verified');
    } else {
      logger.warning('⚠ tmux-yank plugin not found');
    }

    logger.info('Configuration reload complete!');
    logger.info('You may need to restart any affected tmux sessions for all changes to take effect.');

    return { success: true, reloaded: true };
  } catch (error) {
    console.error('\nReload failed:', error.message);
    process.exit(1);
  }
}

module.exports = { reload };
