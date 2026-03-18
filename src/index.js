'use strict';

/**
 * Zsh Starship Config - Main Entry Point
 * 
 * Modern Zsh + Starship + Nerd Fonts setup via npm
 */

const path = require('path');
const fs = require('fs-extra');
const chalk = require('chalk');

// Export main functionality
module.exports = {
  VERSION: require('../package.json').version,
  SCRIPT_DIR: path.join(__dirname, '..'),
  
  // Core functionality
  install: require('./commands/install'),
  update: require('./commands/update'),
  status: require('./commands/status'),
  theme: require('./commands/theme'),
  config: require('./commands/config'),
  rollback: require('./commands/rollback'),
  backup: require('./commands/backup'),
  
  // Utilities
  utils: require('./utils'),
  logger: require('./utils/logger'),
  configManager: require('./utils/config-manager'),
  componentManager: require('./utils/component-manager'),
  errorHandler: require('./utils/error-handler')
};

// Ensure required directories exist
const ensureDirectories = async () => {
  const dirs = [
    path.join(process.env.HOME, '.zsc'),
    path.join(process.env.HOME, '.zsc', 'backups'),
    path.join(process.env.HOME, '.zsc', 'cache'),
    path.join(process.env.HOME, '.zsc', 'logs'),
    path.join(process.env.HOME, '.zsc', 'config'),
    path.join(process.env.HOME, '.zsc', 'tmp')
  ];

  for (const dir of dirs) {
    await fs.ensureDir(dir);
  }
};

// Initialize on import
ensureDirectories().catch(err => {
  console.error(chalk.red('Failed to initialize directories:'), err.message);
});
