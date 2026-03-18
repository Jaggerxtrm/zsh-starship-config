'use strict';

// Export all utility modules
module.exports = {
  Logger: require('./logger').Logger,
  createLogger: require('./logger').createLogger,
  ErrorHandler: require('./error-handler'),
  ConfigManager: require('./config-manager'),
  ComponentManager: require('./component-manager'),
  
  // Common utilities
  paths: require('./paths'),
  system: require('./system'),
  downloader: require('./downloader'),
  backup: require('./backup')
};
