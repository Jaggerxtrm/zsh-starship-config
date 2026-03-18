'use strict';

const fs = require('fs-extra');
const path = require('path');
const https = require('https');
const http = require('http');
const { URL } = require('url');
const progress = require('progress');

/**
 * Download utilities for zsc
 */

class Downloader {
  constructor(logger) {
    this.logger = logger;
  }

  /**
   * Download file with progress
   */
  async downloadFile(url, outputPath, options = {}) {
    const {
      showProgress = true,
      retries = 3,
      timeout = 30000
    } = options;

    const filename = path.basename(outputPath);
    let attempt = 1;

    while (attempt <= retries) {
      try {
        this.logger.debug(`Download attempt ${attempt}/${retries}: ${url}`);
        await this._downloadSingle(url, outputPath, { showProgress, timeout });
        this.logger.success(`Downloaded: ${filename}`);
        return { success: true };
      } catch (error) {
        this.logger.warning(`Download attempt ${attempt} failed: ${error.message}`);
        
        if (attempt < retries) {
          const waitTime = Math.pow(2, attempt) * 1000;
          this.logger.info(`Retrying in ${waitTime}ms...`);
          await this._sleep(waitTime);
        } else {
          throw new Error(`Failed to download after ${retries} attempts: ${error.message}`);
        }
      }
      
      attempt++;
    }
  }

  /**
   * Download single file
   */
  _downloadSingle(url, outputPath, options = {}) {
    return new Promise((resolve, reject) => {
      const protocol = url.startsWith('https') ? https : http;
      const parsedUrl = new URL(url);
      
      const requestOptions = {
        hostname: parsedUrl.hostname,
        port: parsedUrl.port || (protocol === https ? 443 : 80),
        path: parsedUrl.pathname + parsedUrl.search,
        method: 'GET',
        timeout: options.timeout || 30000
      };

      const req = protocol.request(requestOptions, (res) => {
        if (res.statusCode !== 200) {
          reject(new Error(`HTTP ${res.statusCode}: ${res.statusMessage}`));
          return;
        }

        const totalSize = parseInt(res.headers['content-length'], 10);
        let downloadedSize = 0;
        const chunks = [];

        // Progress bar
        let progressBar = null;
        if (options.showProgress && totalSize) {
          progressBar = new progress('  Downloading [:bar] :percent :etas', {
            complete: '=',
            incomplete: ' ',
            width: 40,
            total: totalSize
          });
        }

        res.on('data', (chunk) => {
          chunks.push(chunk);
          downloadedSize += chunk.length;

          if (progressBar) {
            progressBar.update(downloadedSize);
          }
        });

        res.on('end', async () => {
          if (progressBar) {
            progressBar.terminate();
          }

          try {
            const buffer = Buffer.concat(chunks);
            await fs.ensureDir(path.dirname(outputPath));
            await fs.writeFile(outputPath, buffer);
            resolve({ success: true, size: buffer.length });
          } catch (error) {
            reject(new Error(`Failed to write file: ${error.message}`));
          }
        });
      });

      req.on('error', (error) => {
        reject(new Error(`Download failed: ${error.message}`));
      });

      req.on('timeout', () => {
        req.destroy();
        reject(new Error('Download timeout'));
      });

      req.setTimeout(options.timeout || 30000);
      req.end();
    });
  }

  /**
   * Download and extract archive
   */
  async downloadAndExtract(url, extractPath, options = {}) {
    const {
      archiveType = 'auto',
      stripComponents = 0
    } = options;

    const tempPath = path.join(extractPath, '.download-temp');
    const filename = path.basename(url);
    const downloadPath = path.join(tempPath, filename);

    try {
      // Download
      await this.downloadFile(url, downloadPath, options);

      // Extract
      await this._extractArchive(downloadPath, extractPath, { archiveType, stripComponents });

      // Cleanup
      await fs.remove(tempPath);

      this.logger.success(`Extracted to: ${extractPath}`);
      return { success: true };
    } catch (error) {
      // Cleanup on error
      await fs.remove(tempPath);
      throw error;
    }
  }

  /**
   * Extract archive
   */
  async _extractArchive(archivePath, extractPath, options = {}) {
    const { archiveType = 'auto', stripComponents = 0 } = options;

    const ext = path.extname(archivePath).toLowerCase();
    let type = archiveType;

    if (type === 'auto') {
      if (ext === '.tar' || ext === '.tgz') type = 'tar';
      else if (ext === '.tar.gz' || ext === '.tgz') type = 'tar.gz';
      else if (ext === '.tar.xz') type = 'tar.xz';
      else if (ext === '.zip') type = 'zip';
      else throw new Error(`Unknown archive type: ${ext}`);
    }

    switch (type) {
      case 'tar':
      case 'tar.gz':
      case 'tar.xz':
        await this._extractTar(archivePath, extractPath, stripComponents);
        break;
      case 'zip':
        await this._extractZip(archivePath, extractPath, stripComponents);
        break;
      default:
        throw new Error(`Unsupported archive type: ${type}`);
    }
  }

  /**
   * Extract tar archive
   */
  async _extractTar(archivePath, extractPath, stripComponents) {
    const { execSync } = require('child_process');
    
    const command = stripComponents > 0
      ? `tar --strip-components=${stripComponents} -xf "${archivePath}" -C "${extractPath}"`
      : `tar -xf "${archivePath}" -C "${extractPath}"`;

    try {
      execSync(command, { stdio: 'inherit' });
    } catch (error) {
      throw new Error(`Failed to extract tar archive: ${error.message}`);
    }
  }

  /**
   * Extract zip archive
   */
  async _extractZip(zipPath, extractPath, stripComponents) {
    const AdmZip = require('adm-zip');
    
    try {
      const zip = new AdmZip(zipPath);
      zip.extractAllTo(extractPath, true);
    } catch (error) {
      throw new Error(`Failed to extract zip archive: ${error.message}`);
    }
  }

  /**
   * Download multiple files
   */
  async downloadMany(urls, outputDir, options = {}) {
    const {
      parallel = false,
      concurrency = 3
    } = options;

    const results = [];
    const errors = [];

    if (parallel) {
      // Parallel download with concurrency limit
      const chunks = [];
      for (let i = 0; i < urls.length; i += concurrency) {
        chunks.push(urls.slice(i, i + concurrency));
      }

      for (const chunk of chunks) {
        const promises = chunk.map(url => {
          const filename = path.basename(url);
          const outputPath = path.join(outputDir, filename);
          
          return this.downloadFile(url, outputPath, options)
            .catch(error => ({ url, error: error.message }));
        });

        const chunkResults = await Promise.all(promises);
        chunkResults.forEach(result => {
          if (result.error) {
            errors.push(result);
          } else {
            results.push(result);
          }
        });
      }
    } else {
      // Sequential download
      for (const url of urls) {
        const filename = path.basename(url);
        const outputPath = path.join(outputDir, filename);
        
        try {
          await this.downloadFile(url, outputPath, options);
          results.push({ url, success: true });
        } catch (error) {
          errors.push({ url, error: error.message });
        }
      }
    }

    return {
      results,
      errors,
      allSuccessful: errors.length === 0
    };
  }

  /**
   * Download from GitHub release
   */
  async downloadFromGitHub(repo, asset, outputDir, options = {}) {
    const { version = 'latest' } = options;

    const apiUrl = version === 'latest'
      ? `https://api.github.com/repos/${repo}/releases/latest`
      : `https://api.github.com/repos/${repo}/releases/tags/${version}`;

    try {
      const axios = require('axios');
      const response = await axios.get(apiUrl);
      const release = response.data;

      const assetData = release.assets.find(a => a.name.includes(asset) || a.name === asset);
      
      if (!assetData) {
        throw new Error(`Asset not found: ${asset}`);
      }

      const outputPath = path.join(outputDir, assetData.name);
      await this.downloadFile(assetData.browser_download_url, outputPath, options);

      return { success: true, version: release.tag_name };
    } catch (error) {
      throw new Error(`Failed to download from GitHub: ${error.message}`);
    }
  }

  /**
   * Get latest version from GitHub
   */
  async getLatestGitHubVersion(repo) {
    try {
      const axios = require('axios');
      const response = await axios.get(`https://api.github.com/repos/${repo}/releases/latest`);
      return response.data.tag_name;
    } catch (error) {
      throw new Error(`Failed to get latest version: ${error.message}`);
    }
  }

  /**
   * Sleep utility
   */
  _sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

module.exports = Downloader;
