#!/usr/bin/env node

const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

// Path to the install.sh script in the package root
const installScript = path.join(__dirname, '..', 'install.sh');

// Ensure install.sh is executable
try {
  fs.chmodSync(installScript, '755');
} catch (err) {
  console.error('Error setting permissions on install.sh:', err);
  process.exit(1);
}

// Pass all arguments from the CLI to the shell script
const args = process.argv.slice(2);

console.log('🚀 Launching Zsh Starship Config Installer via npx...');

// Spawn the shell script
const child = spawn(installScript, args, {
  stdio: 'inherit', // Pipe stdin/out/err to the parent process
  cwd: path.join(__dirname, '..'), // Run from package root so SCRIPT_DIR works
  env: process.env // Inherit environment variables
});

child.on('close', (code) => {
  process.exit(code);
});

child.on('error', (err) => {
  console.error('Failed to start installer:', err);
  process.exit(1);
});
