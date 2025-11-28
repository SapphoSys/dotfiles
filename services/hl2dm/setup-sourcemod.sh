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
# Only download if not already installed
if [[ ! -f "$SM_DIR/bin/sourcemod.so" ]] && [[ ! -f "$SM_DIR/bin/sourcepawn.so" ]]; then
  echo "Downloading SourceMod..."
  cd /tmp
  
  # Get the latest filename from the symlink
  LATEST_SM=$(wget -q -O - "https://sm.alliedmods.net/smdrop/1.13/sourcemod-latest-linux" 2>/dev/null | tr -d '\n' | tr -d ' ')
  
  if [[ -z "$LATEST_SM" ]]; then
    echo "✗ Failed to determine latest SourceMod version"
    exit 1
  fi
  
  echo "Latest SourceMod build: $LATEST_SM"
  
  if wget --timeout=30 "https://sm.alliedmods.net/smdrop/1.13/$LATEST_SM" -O sourcemod.tar.gz 2>&1; then
    echo "Download completed, checking file..."
    if [[ -f sourcemod.tar.gz ]] && [[ -s sourcemod.tar.gz ]]; then
      echo "Extracting SourceMod..."
      # Remove existing directory completely to avoid conflicts
      rm -rf "$SM_DIR"
      
      # Extract directly into addons parent directory - the tar should have addons/sourcemod structure
      if tar -xzf sourcemod.tar.gz -C "$SERVERDIR" 2>&1; then
        rm -f sourcemod.tar.gz
        
        # Verify it worked
        if [[ -d "$SM_DIR/bin" ]] && [[ -f "$SM_DIR/bin/sourcemod.so" ]]; then
          echo "✓ SourceMod installed successfully"
        else
          echo "⚠ SourceMod extracted but bin/sourcemod.so not found - may have different structure"
          ls -la "$SM_DIR" 2>/dev/null || echo "Directory listing failed"
        fi
      else
        echo "✗ Failed to extract SourceMod tarball"
        exit 1
      fi
    else
      echo "✗ Downloaded file is empty or not found"
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
  echo "Downloading MetaMod:Source..."
  cd /tmp
  
  # Get the latest filename from the symlink
  LATEST_MM=$(wget -q -O - "https://mms.alliedmods.net/mmsdrop/2.0/mmsource-latest-linux" 2>/dev/null | tr -d '\n' | tr -d ' ')
  
  if [[ -z "$LATEST_MM" ]]; then
    echo "✗ Failed to determine latest MetaMod:Source version"
    exit 1
  fi
  
  echo "Latest MetaMod:Source build: $LATEST_MM"
  
  if wget --timeout=30 "https://mms.alliedmods.net/mmsdrop/2.0/$LATEST_MM" -O metamod.tar.gz 2>&1; then
    echo "Download completed, checking file..."
    if [[ -f metamod.tar.gz ]] && [[ -s metamod.tar.gz ]]; then
      echo "Extracting MetaMod:Source (excluding 64-bit binaries)..."
      # Remove existing directory completely to avoid conflicts
      rm -rf "$MM_DIR"
      
      # Extract directly into addons parent directory, excluding 64-bit directories
      # HL2DM is 32-bit only, so we don't want the tar to extract linux64/
      if tar -xzf metamod.tar.gz -C "$SERVERDIR" \
          --exclude='addons/metamod/bin/linux64' \
          --exclude='addons/metamod/bin/linuxsteamrt64' 2>&1; then
        rm -f metamod.tar.gz
        
        # Verify it worked
        if [[ -d "$MM_DIR/bin" ]] && [[ -f "$MM_DIR/bin/server.so" ]]; then
          echo "✓ MetaMod:Source installed successfully"
        else
          echo "⚠ MetaMod:Source extracted but bin/server.so not found - may have different structure"
          ls -la "$MM_DIR" 2>/dev/null || echo "Directory listing failed"
        fi
      else
        echo "✗ Failed to extract MetaMod tarball"
        exit 1
      fi
    else
      echo "✗ Downloaded file is empty or not found"
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

# Fix MetaMod binary for 32-bit HL2DM
# Ensure the 32-bit binary is accessible
echo "Verifying MetaMod 32-bit binary..."

if [[ -f "$MM_DIR/bin/server.so" ]]; then
  echo "✓ MetaMod 32-bit binary confirmed"
  
  # HL2DM has a game-specific binary: metamod.2.hl2dm.so
  # Make sure it's being used by creating a symlink or copy to the expected location
  if [[ -f "$MM_DIR/bin/metamod.2.hl2dm.so" ]]; then
    echo "Found HL2DM-specific MetaMod binary, ensuring it's linked..."
    # Some engines look for server_hl2dm.so
    if [[ ! -L "$MM_DIR/bin/server_hl2dm.so" ]] && [[ ! -f "$MM_DIR/bin/server_hl2dm.so" ]]; then
      ln -sf metamod.2.hl2dm.so "$MM_DIR/bin/server_hl2dm.so" 2>/dev/null || true
    fi
  fi
  
  # Double-check that 64-bit directories don't exist (they would cause loading failures)
  if [[ -d "$MM_DIR/bin/linux64" ]]; then
    echo "⚠ Found 64-bit directory that should have been removed, cleaning up..."
    rm -rf "$MM_DIR/bin/linux64"
  fi
else
  echo "⚠ Warning: Could not find 32-bit MetaMod binary"
  echo "Available binaries:"
  find "$MM_DIR/bin" -maxdepth 1 -name "*.so" 2>/dev/null | head -10 || true
fi

# Copy SourceMod configuration files if they exist
echo "=== Setting up MetaMod configuration ==="
# Configure metaplugins.ini to load SourceMod
MM_PLUGINS_INI="$MM_DIR/metaplugins.ini"
if [[ -f "$MM_PLUGINS_INI" ]]; then
  # Check if SourceMod is already in the config
  if ! grep -q "sourcemod_mm" "$MM_PLUGINS_INI"; then
    echo "Adding SourceMod to metaplugins.ini..."
    # Append SourceMod plugin entry (without _i486.so extension as per metaplugins.ini format)
    echo "addons/sourcemod/bin/sourcemod_mm" >> "$MM_PLUGINS_INI"
    echo "✓ SourceMod plugin registered with MetaMod"
  else
    echo "✓ SourceMod already registered in metaplugins.ini"
  fi
else
  echo "⚠ metaplugins.ini not found - MetaMod plugin loading may not work"
fi

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
