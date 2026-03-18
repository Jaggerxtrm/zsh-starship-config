'use strict';

const fs = require('fs-extra');
const path = require('path');
const os = require('os');
const crypto = require('crypto');
const AdmZip = require('adm-zip');

/**
 * Backup utilities for zsc
 */

const BACKUP_DIR = path.join(os.homedir(), '.zsc', 'backups');
const BACKUP_STATE_FILE = path.join(BACKUP_DIR, 'backup-state.json');

class BackupManager {
  constructor(logger) {
    this.logger = logger;
    this.backupState = {};
  }

  /**
   * Initialize backup system
   */
  async init() {
    await fs.ensureDir(BACKUP_DIR);
    await this.loadState();
  }

  /**
   * Load backup state
   */
  async loadState() {
    try {
      if (await fs.pathExists(BACKUP_STATE_FILE)) {
        const stateData = await fs.readFile(BACKUP_STATE_FILE, 'utf8');
        this.backupState = JSON.parse(stateData);
      }
    } catch (error) {
      this.logger.warning('Failed to load backup state:', error.message);
      this.backupState = {};
    }
  }

  /**
   * Save backup state
   */
  async saveState() {
    try {
      await fs.writeFile(BACKUP_STATE_FILE, JSON.stringify(this.backupState, null, 2));
    } catch (error) {
      this.logger.error('Failed to save backup state:', error);
    }
  }

  /**
   * Create backup of a file or directory
   */
  async backup(source, options = {}) {
    const {
      compress = false,
      prefix = 'backup',
      component = null
    } = options;

    if (!await fs.pathExists(source)) {
      throw new Error(`Source does not exist: ${source}`);
    }

    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const hash = this._generateHash(source);
    const sourceName = path.basename(source);
    const backupName = `${prefix}-${sourceName}-${timestamp}-${hash}`;
    const backupPath = path.join(BACKUP_DIR, backupName);

    try {
      // Create backup
      if (compress) {
        await this._backupCompressed(source, backupPath);
      } else {
        await this._backupCopy(source, backupPath);
      }

      // Update state
      this.backupState[source] = {
        timestamp,
        path: backupPath,
        component,
        compressed: compress,
        hash
      };
      await this.saveState();

      this.logger.success(`Backup created: ${backupName}`);
      return { success: true, path: backupPath, timestamp };
    } catch (error) {
      throw new Error(`Failed to create backup: ${error.message}`);
    }
  }

  /**
   * Create uncompressed backup
   */
  async _backupCopy(source, destPath) {
    await fs.copy(source, destPath);
  }

  /**
   * Create compressed backup
   */
  async _backupCompressed(source, destPath) {
    const zipPath = destPath + '.zip';
    const zip = new AdmZip();

    if ((await fs.stat(source)).isDirectory()) {
      zip.addLocalFolder(source);
    } else {
      zip.addLocalFile(source);
    }

    zip.writeZip(zipPath);
    return zipPath;
  }

  /**
   * Backup multiple files/directories
   */
  async backupMany(sources, options = {}) {
    const results = [];
    const errors = [];

    for (const source of sources) {
      try {
        const result = await this.backup(source, options);
        results.push({ source, ...result });
      } catch (error) {
        errors.push({ source, error: error.message });
      }
    }

    return {
      results,
      errors,
      allSuccessful: errors.length === 0
    };
  }

  /**
   * Restore from backup
   */
  async restore(backupPath, destination, options = {}) {
    const {
      overwrite = false,
      createBackup = true
    } = options;

    if (!await fs.pathExists(backupPath)) {
      throw new Error(`Backup does not exist: ${backupPath}`);
    }

    try {
      // Create backup of current state before restoring
      if (createBackup && await fs.pathExists(destination)) {
        await this.backup(destination, { prefix: 'pre-restore' });
      }

      // Check if destination exists
      if (await fs.pathExists(destination)) {
        if (!overwrite) {
          throw new Error(`Destination already exists: ${destination}`);
        }
        await fs.remove(destination);
      }

      // Restore
      const isCompressed = backupPath.endsWith('.zip');
      if (isCompressed) {
        await this._restoreCompressed(backupPath, destination);
      } else {
        await this._restoreCopy(backupPath, destination);
      }

      this.logger.success(`Restored from: ${backupPath}`);
      return { success: true, path: destination };
    } catch (error) {
      throw new Error(`Failed to restore: ${error.message}`);
    }
  }

  /**
   * Restore uncompressed backup
   */
  async _restoreCopy(source, destPath) {
    await fs.copy(source, destPath);
  }

  /**
   * Restore compressed backup
   */
  async _restoreCompressed(source, destPath) {
    const zip = new AdmZip(source);
    zip.extractAllTo(destPath, true);
  }

  /**
   * List all backups
   */
  async listBackups(options = {}) {
    const {
      component = null,
      source = null
    } = options;

    const backups = [];

    for (const [sourcePath, state] of Object.entries(this.backupState)) {
      // Filter by component
      if (component && state.component !== component) continue;

      // Filter by source
      if (source && !sourcePath.includes(source)) continue;

      // Get file stats
      const stats = await fs.pathExists(state.path)
        ? await fs.stat(state.path)
        : null;

      backups.push({
        source: sourcePath,
        path: state.path,
        timestamp: state.timestamp,
        component: state.component,
        compressed: state.compressed,
        exists: stats !== null,
        size: stats?.size || 0,
        hash: state.hash
      });
    }

    // Sort by timestamp (newest first)
    backups.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));

    return backups;
  }

  /**
   * Delete backup
   */
  async deleteBackup(backupPath, options = {}) {
    const {
      verifySource = true
    } = options;

    if (!await fs.pathExists(backupPath)) {
      throw new Error(`Backup does not exist: ${backupPath}`);
    }

    try {
      await fs.remove(backupPath);

      // Remove from state
      if (verifySource) {
        const sourceKey = Object.keys(this.backupState).find(
          key => this.backupState[key].path === backupPath
        );

        if (sourceKey) {
          delete this.backupState[sourceKey];
          await this.saveState();
        }
      }

      this.logger.success(`Backup deleted: ${backupPath}`);
      return { success: true };
    } catch (error) {
      throw new Error(`Failed to delete backup: ${error.message}`);
    }
  }

  /**
   * Clean old backups
   */
  async cleanOld(options = {}) {
    const {
      keep = 5,
      component = null
    } = options;

    const backups = await this.listBackups({ component });

    if (backups.length <= keep) {
      this.logger.info(`No old backups to clean (keeping ${keep} most recent)`);
      return { deleted: 0, kept: backups.length };
    }

    // Delete oldest backups beyond keep limit
    const toDelete = backups.slice(keep);
    let deletedCount = 0;

    for (const backup of toDelete) {
      try {
        await this.deleteBackup(backup.path, { verifySource: false });
        deletedCount++;
      } catch (error) {
        this.logger.warning(`Failed to delete old backup: ${error.message}`);
      }
    }

    // Update state
    for (const backup of toDelete) {
      const sourceKey = Object.keys(this.backupState).find(
        key => this.backupState[key].path === backup.path
      );

      if (sourceKey) {
        delete this.backupState[sourceKey];
      }
    }
    await this.saveState();

    this.logger.success(`Cleaned ${deletedCount} old backup(s)`);
    return { deleted: deletedCount, kept: backups.length - deletedCount };
  }

  /**
   * Get backup info
   */
  async getBackupInfo(backupPath) {
    if (!await fs.pathExists(backupPath)) {
      throw new Error(`Backup does not exist: ${backupPath}`);
    }

    const sourceKey = Object.keys(this.backupState).find(
      key => this.backupState[key].path === backupPath
    );

    const state = sourceKey ? this.backupState[sourceKey] : null;
    const stats = await fs.stat(backupPath);

    return {
      path: backupPath,
      source: sourceKey,
      timestamp: state?.timestamp,
      component: state?.component,
      compressed: state?.compressed,
      size: stats.size,
      createdAt: stats.ctime,
      modifiedAt: stats.mtime,
      hash: state?.hash
    };
  }

  /**
   * Create snapshot of current configuration
   */
  async createSnapshot(name, options = {}) {
    const {
      includeConfig = true,
      includeState = true,
      compress = true
    } = options;

    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const snapshotName = `snapshot-${name}-${timestamp}`;
    const snapshotPath = path.join(BACKUP_DIR, snapshotName);
    const zipPath = snapshotPath + '.zip';

    try {
      const zip = new AdmZip();

      // Add configuration
      if (includeConfig) {
        const configFile = path.join(os.homedir(), '.zsc', 'config.json');
        if (await fs.pathExists(configFile)) {
          zip.addLocalFile(configFile, 'config.json');
        }
      }

      // Add state
      if (includeState) {
        const stateFile = path.join(os.homedir(), '.zsc', 'state.json');
        if (await fs.pathExists(stateFile)) {
          zip.addLocalFile(stateFile, 'state.json');
        }
      }

      zip.writeZip(zipPath);

      this.logger.success(`Snapshot created: ${snapshotName}`);
      return { success: true, path: zipPath, timestamp };
    } catch (error) {
      throw new Error(`Failed to create snapshot: ${error.message}`);
    }
  }

  /**
   * Restore from snapshot
   */
  async restoreSnapshot(snapshotPath, options = {}) {
    const {
      restoreConfig = true,
      restoreState = true
    } = options;

    if (!await fs.pathExists(snapshotPath)) {
      throw new Error(`Snapshot does not exist: ${snapshotPath}`);
    }

    try {
      const zip = new AdmZip(snapshotPath);
      const tempDir = path.join(BACKUP_DIR, '.temp');

      // Extract to temp
      await fs.ensureDir(tempDir);
      zip.extractAllTo(tempDir, true);

      // Restore config
      if (restoreConfig) {
        const configFile = path.join(tempDir, 'config.json');
        if (await fs.pathExists(configFile)) {
          await fs.copy(configFile, path.join(os.homedir(), '.zsc', 'config.json'));
        }
      }

      // Restore state
      if (restoreState) {
        const stateFile = path.join(tempDir, 'state.json');
        if (await fs.pathExists(stateFile)) {
          await fs.copy(stateFile, path.join(os.homedir(), '.zsc', 'state.json'));
        }
      }

      // Cleanup
      await fs.remove(tempDir);

      this.logger.success(`Snapshot restored: ${path.basename(snapshotPath)}`);
      return { success: true };
    } catch (error) {
      throw new Error(`Failed to restore snapshot: ${error.message}`);
    }
  }

  /**
   * Generate hash for file path
   */
  _generateHash(str) {
    return crypto.createHash('md5').update(str).digest('hex').substring(0, 8);
  }

  /**
   * Get backup statistics
   */
  async getStatistics() {
    const backups = await this.listBackups();
    const totalSize = backups.reduce((sum, b) => sum + b.size, 0);

    return {
      totalBackups: backups.length,
      totalSize,
      totalSizeFormatted: this._formatBytes(totalSize),
      oldest: backups.length > 0 ? backups[backups.length - 1].timestamp : null,
      newest: backups.length > 0 ? backups[0].timestamp : null,
      byComponent: this._groupByComponent(backups)
    };
  }

  /**
   * Group backups by component
   */
  _groupByComponent(backups) {
    const grouped = {};

    for (const backup of backups) {
      const component = backup.component || 'unknown';
      if (!grouped[component]) {
        grouped[component] = 0;
      }
      grouped[component]++;
    }

    return grouped;
  }

  /**
   * Format bytes
   */
  _formatBytes(bytes) {
    if (bytes === 0) return '0 B';

    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));

    return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
  }
}

module.exports = BackupManager;
