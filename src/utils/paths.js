'use strict';

const path = require('path');
const os = require('os');

/**
 * Path utilities for zsc
 */

// Base paths
const HOME = os.homedir();
const CONFIG_DIR = path.join(HOME, '.zsc');
const REPO_ROOT = path.join(__dirname, '..', '..');

// Subdirectories
const paths = {
  // Home directory
  home: HOME,

  // zsc directories
  configDir: CONFIG_DIR,
  cacheDir: path.join(CONFIG_DIR, 'cache'),
  logsDir: path.join(CONFIG_DIR, 'logs'),
  backupDir: path.join(CONFIG_DIR, 'backups'),
  tmpDir: path.join(CONFIG_DIR, 'tmp'),

  // Configuration files
  configFile: path.join(CONFIG_DIR, 'config.json'),
  stateFile: path.join(CONFIG_DIR, 'state.json'),
  rollbackFile: path.join(CONFIG_DIR, 'rollback.json'),

  // System configuration paths
  zshrc: path.join(HOME, '.zshrc'),
  ohMyZsh: path.join(HOME, '.oh-my-zsh'),
  zshCustom: path.join(HOME, '.oh-my-zsh', 'custom'),
  starshipConfig: path.join(HOME, '.config', 'starship.toml'),
  tmuxConfig: path.join(HOME, '.tmux.conf'),
  tmuxDir: path.join(HOME, '.tmux'),
  tmuxPlugins: path.join(HOME, '.tmux', 'plugins'),
  tmuxThemes: path.join(HOME, '.tmux', 'themes.sh'),

  // Binary paths
  localBin: path.join(HOME, '.local', 'bin'),
  fontsDir: path.join(HOME, '.local', 'share', 'fonts'),

  // Claude Code
  claudeDir: path.join(HOME, '.claude'),
  claudeHooks: path.join(HOME, '.claude', 'hooks'),
  claudeConfig: path.join(HOME, '.claude', 'settings.json'),
  claudeStatusline: path.join(HOME, '.claude', 'hooks', 'statusline-starship.sh'),

  // Repository paths
  repoRoot: REPO_ROOT,
  repoData: path.join(REPO_ROOT, 'data'),
  repoScripts: path.join(REPO_ROOT, 'scripts'),
  repoBin: path.join(REPO_ROOT, 'bin')
};

/**
 * Ensure all paths exist
 */
async function ensurePaths() {
  const fs = require('fs-extra');

  const dirsToCreate = [
    paths.configDir,
    paths.cacheDir,
    paths.logsDir,
    paths.backupDir,
    paths.tmpDir,
    paths.zshCustom,
    paths.tmuxDir,
    paths.tmuxPlugins,
    paths.localBin,
    paths.fontsDir,
    paths.claudeHooks
  ];

  for (const dir of dirsToCreate) {
    await fs.ensureDir(dir);
  }
}

/**
 * Get cache path for a component
 */
function getCachePath(component) {
  return path.join(paths.cacheDir, component);
}

/**
 * Get backup path with timestamp
 */
function getBackupPath(component) {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  return path.join(paths.backupDir, `${component}-${timestamp}`);
}

/**
 * Get temp path
 */
function getTempPath(suffix = '') {
  const timestamp = Date.now();
  return path.join(paths.tmpDir, `tmp-${timestamp}${suffix ? '-' + suffix : ''}`);
}

/**
 * Resolve path relative to home directory
 */
function resolveHome(relativePath) {
  return path.join(HOME, relativePath.replace(/^~/, ''));
}

/**
 * Make path relative to home for display
 */
function makeRelative(absolutePath) {
  if (absolutePath.startsWith(HOME)) {
    return '~' + absolutePath.slice(HOME.length);
  }
  return absolutePath;
}

module.exports = {
  ...paths,
  ensurePaths,
  getCachePath,
  getBackupPath,
  getTempPath,
  resolveHome,
  makeRelative
};
