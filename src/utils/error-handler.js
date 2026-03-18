'use strict';

const chalk = require('chalk');
const fs = require('fs-extra');
const path = require('path');

const ERROR_LOGS_DIR = path.join(process.env.HOME, '.zsc', 'logs');
const ERROR_LOG_FILE = path.join(ERROR_LOGS_DIR, 'errors.log');

class ErrorHandler {
  constructor(logger) {
    this.logger = logger;
    this.errors = [];
    this.warnings = [];
  }

  /**
   * Handle different types of errors with appropriate formatting
   */
  handleError(error, context = {}) {
    const errorInfo = {
      timestamp: new Date().toISOString(),
      type: this._getErrorType(error),
      message: error.message || String(error),
      stack: error.stack,
      context
    };

    this.errors.push(errorInfo);
    this._logError(errorInfo);

    throw error; // Re-throw for calling code to handle
  }

  /**
   * Handle error without throwing
   */
  catch(error, context = {}) {
    const errorInfo = {
      timestamp: new Date().toISOString(),
      type: this._getErrorType(error),
      message: error.message || String(error),
      stack: error.stack,
      context
    };

    this.errors.push(errorInfo);
    this._logError(errorInfo);

    return errorInfo;
  }

  /**
   * Add warning
   */
  addWarning(message, context = {}) {
    const warningInfo = {
      timestamp: new Date().toISOString(),
      message,
      context
    };

    this.warnings.push(warningInfo);
    this._logWarning(warningInfo);

    return warningInfo;
  }

  /**
   * Determine error type
   */
  _getErrorType(error) {
    if (error.code === 'EACCES') return 'PERMISSION';
    if (error.code === 'ENOENT') return 'NOT_FOUND';
    if (error.code === 'EEXIST') return 'EXISTS';
    if (error.code === 'ENOSPC') return 'DISK_SPACE';
    if (error.code === 'ETIMEDOUT') return 'TIMEOUT';
    if (error.code === 'ECONNREFUSED') return 'NETWORK';
    if (error.code === 'ENETUNREACH') return 'NETWORK';

    if (error.name === 'ValidationError') return 'VALIDATION';
    if (error.name === 'ConfigurationError') return 'CONFIGURATION';

    return 'UNKNOWN';
  }

  /**
   * Log error to file and console
   */
  async _logError(errorInfo) {
    // Log to file
    await fs.ensureDir(ERROR_LOGS_DIR);
    await fs.appendFile(ERROR_LOG_FILE, JSON.stringify(errorInfo) + '\n');

    // Log to console via logger
    const message = this._formatErrorMessage(errorInfo);
    this.logger.error(message);
  }

  /**
   * Log warning to file and console
   */
  async _logWarning(warningInfo) {
    // Log to file
    await fs.ensureDir(ERROR_LOGS_DIR);
    await fs.appendFile(ERROR_LOG_FILE, JSON.stringify(warningInfo) + '\n');

    // Log to console via logger
    this.logger.warning(warningInfo.message);
  }

  /**
   * Format error message for display
   */
  _formatErrorMessage(errorInfo) {
    const { type, message, context } = errorInfo;

    let formatted = `${chalk.red('✖')} ${type}: ${message}`;

    if (Object.keys(context).length > 0) {
      formatted += '\n' + chalk.gray('Context: ') + chalk.yellow(JSON.stringify(context, null, 2));
    }

    return formatted;
  }

  /**
   * Get error summary
   */
  getSummary() {
    const errorCount = this.errors.length;
    const warningCount = this.warnings.length;

    return {
      errors: errorCount,
      warnings: warningCount,
      hasErrors: errorCount > 0,
      hasWarnings: warningCount > 0,
      canProceed: errorCount === 0
    };
  }

  /**
   * Print summary
   */
  printSummary() {
    const summary = this.getSummary();

    if (summary.errors === 0 && summary.warnings === 0) {
      this.logger.success('✓ All operations completed without errors or warnings');
      return;
    }

    console.log('\n' + chalk.bold('Summary:'));
    
    if (summary.errors > 0) {
      console.log(chalk.red(`  ✖ Errors: ${summary.errors}`));
    }
    
    if (summary.warnings > 0) {
      console.log(chalk.yellow(`  ⚠ Warnings: ${summary.warnings}`));
    }

    if (summary.canProceed) {
      console.log(chalk.green('  ✓ Operations can proceed despite warnings'));
    } else {
      console.log(chalk.red('  ✖ Cannot proceed due to errors'));
    }
  }

  /**
   * Clear error history
   */
  clear() {
    this.errors = [];
    this.warnings = [];
  }

  /**
   * Retry wrapper
   */
  async retry(fn, options = {}) {
    const {
      maxRetries = 3,
      retryDelay = 1000,
      onError = null
    } = options;

    let lastError;

    for (let attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        return await fn();
      } catch (error) {
        lastError = error;
        
        if (onError) {
          await onError(error, attempt);
        }

        if (attempt < maxRetries) {
          this.logger.warning(`Attempt ${attempt} failed, retrying in ${retryDelay}ms...`);
          await new Promise(resolve => setTimeout(resolve, retryDelay * attempt));
        }
      }
    }

    throw this.handleError(lastError, { 
      attempts: maxRetries,
      finalAttempt: true 
    });
  }

  /**
   * Validation error helper
   */
  static validation(message) {
    const error = new Error(message);
    error.name = 'ValidationError';
    error.code = 'VALIDATION_ERROR';
    return error;
  }

  /**
   * Configuration error helper
   */
  static configuration(message) {
    const error = new Error(message);
    error.name = 'ConfigurationError';
    error.code = 'CONFIG_ERROR';
    return error;
  }

  /**
   * Rollback error helper
   */
  static rollback(message) {
    const error = new Error(message);
    error.name = 'RollbackError';
    error.code = 'ROLLBACK_ERROR';
    return error;
  }
}

module.exports = ErrorHandler;
