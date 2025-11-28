#!/bin/bash
# SourceMod setup script for ich777's docker-steamcmd-server
# This script is called by the image's startup sequence as an optional initialization script
# It downloads and installs SourceMod and MetaMod:Source before the game server starts

echo "=== SourceMod & MetaMod Installation ==="

SERVERDIR="/serverdata/serverfiles/hl2mp"
ADDONSDIR="$SERVERDIR/addons"
SM_DIR="$ADDONSDIR/sourcemod"
MM_DIR="$ADDONSDIR/metamod"

# Create addons directory if it doesn't exist
mkdir -p "$ADDONSDIR"

# Download and install SourceMod (Latest from 1.13 branch)
if [[ ! -f "$SM_DIR/bin/sourcemod.so" ]] && [[ ! -f "$SM_DIR/bin/sourcepawn.so" ]]; then
  echo "Downloading SourceMod from https://sm.alliedmods.net/smdrop/1.13/sourcemod-latest-linux..."
  cd /tmp
  
  # Download with -L to follow symlinks
  if wget -L --timeout=30 "https://sm.alliedmods.net/smdrop/1.13/sourcemod-latest-linux" -O sourcemod.tar.gz 2>&1; then
    echo "Download completed, checking file..."
    if [[ -f sourcemod.tar.gz ]] && [[ -s sourcemod.tar.gz ]]; then
      echo "Extracting SourceMod..."
      # Extract to temp dir first to handle top-level directory
      rm -rf /tmp/sm_extract
      mkdir -p /tmp/sm_extract
      if tar -xzf sourcemod.tar.gz -C /tmp/sm_extract 2>&1; then
        # Move contents, handling if there's a top-level directory
        if [[ -d /tmp/sm_extract/sourcemod ]]; then
          # Has top-level sourcemod directory
          cp -r /tmp/sm_extract/sourcemod/* "$SM_DIR/"
        else
          # No top-level directory, contents are directly in root
          cp -r /tmp/sm_extract/* "$SM_DIR/"
        fi
        rm -rf /tmp/sm_extract sourcemod.tar.gz
        echo "✓ SourceMod installed successfully"
      else
        echo "✗ Failed to extract SourceMod tarball"
        file sourcemod.tar.gz
        exit 1
      fi
    else
      echo "✗ Downloaded file is empty or not found"
      file sourcemod.tar.gz 2>&1
      exit 1
    fi
  else
    echo "✗ Failed to download SourceMod"
    exit 1
  fi
else
  echo "✓ SourceMod already installed"
fi

# Download and install MetaMod:Source (Latest from 2.0 branch)
if [[ ! -f "$MM_DIR/bin/server.so" ]]; then
  echo "Downloading MetaMod:Source from https://mms.alliedmods.net/mmsdrop/2.0/mmsource-latest-linux..."
  cd /tmp
  
  # Download with -L to follow symlinks
  if wget -L --timeout=30 "https://mms.alliedmods.net/mmsdrop/2.0/mmsource-latest-linux" -O metamod.tar.gz 2>&1; then
    echo "Download completed, checking file..."
    if [[ -f metamod.tar.gz ]] && [[ -s metamod.tar.gz ]]; then
      echo "Extracting MetaMod:Source..."
      # Extract to temp dir first to handle top-level directory
      rm -rf /tmp/mm_extract
      mkdir -p /tmp/mm_extract
      if tar -xzf metamod.tar.gz -C /tmp/mm_extract 2>&1; then
        # Move contents, handling if there's a top-level directory
        if [[ -d /tmp/mm_extract/metamod ]]; then
          # Has top-level metamod directory
          cp -r /tmp/mm_extract/metamod/* "$MM_DIR/"
        else
          # No top-level directory, contents are directly in root
          cp -r /tmp/mm_extract/* "$MM_DIR/"
        fi
        rm -rf /tmp/mm_extract metamod.tar.gz
        echo "✓ MetaMod:Source installed successfully"
      else
        echo "✗ Failed to extract MetaMod tarball"
        file metamod.tar.gz
        exit 1
      fi
    else
      echo "✗ Downloaded file is empty or not found"
      file metamod.tar.gz 2>&1
      exit 1
    fi
  else
    echo "✗ Failed to download MetaMod:Source"
    exit 1
  fi
else
  echo "✓ MetaMod:Source already installed"
fi

# Set proper permissions for addons
echo "Setting permissions on addons directory..."
chmod -R 755 "$ADDONSDIR" 2>&1 || true

# Copy SourceMod configuration files if they exist
echo "=== Setting up SourceMod configuration ==="
if [[ -d "$SM_DIR/configs" ]]; then
  if [[ -f "/serverdata/sourcemod.cfg" ]]; then
    echo "Copying sourcemod.cfg..."
    if cp -v "/serverdata/sourcemod.cfg" "$SM_DIR/configs/sourcemod.cfg" 2>&1; then
      echo "✓ Copied sourcemod.cfg"
    else
      echo "⚠ Could not copy sourcemod.cfg (might be normal)"
    fi
  fi
  
  if [[ -f "/serverdata/admins.cfg" ]]; then
    echo "Copying admins.cfg..."
    if cp -v "/serverdata/admins.cfg" "$SM_DIR/configs/admins.cfg" 2>&1; then
      echo "✓ Copied admins.cfg"
    else
      echo "⚠ Could not copy admins.cfg (might be normal)"
    fi
  fi
  
  # Fix permissions on the copied files
  chmod 644 "$SM_DIR/configs/"*.cfg 2>&1 || true
  echo "Config files deployed"
else
  echo "⚠ SourceMod configs directory not found - installation may have failed"
fi

echo "=== SourceMod setup complete ==="
