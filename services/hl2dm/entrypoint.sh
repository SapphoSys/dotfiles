#!/bin/bash
# Custom entrypoint for HL2DM container
# Sets up SDK files before game server starts

echo "=== HL2DM SDK Setup ==="

# Wait for steamcmd to complete initial setup
sleep 3

SDKDIR="/serverdata/.steam/sdk32"
STEAMCMDDIR="/serverdata/steamcmd/linux32"
SERVERDIR="/serverdata/serverfiles/hl2mp"
ADDONSDIR="$SERVERDIR/addons"

echo "SDK directory: $SDKDIR"
echo "SteamCMD directory: $STEAMCMDDIR"
echo "Server directory: $SERVERDIR"

# Create SDK directory if needed
mkdir -p "$SDKDIR"

# Copy SDK files from steamcmd
if [[ -d "$STEAMCMDDIR" ]]; then
  echo "Copying SDK files..."
  cp -vf "$STEAMCMDDIR"/* "$SDKDIR/" 2>&1 | head -20
  echo "Done copying SDK files"
else
  echo "Warning: $STEAMCMDDIR not found yet"
fi

# List what we have
echo "SDK directory contents:"
ls -la "$SDKDIR" | head -20

echo "=== Setting up SourceMod ==="

# Create addons directory
mkdir -p "$ADDONSDIR"

SM_DIR="$ADDONSDIR/sourcemod"
MM_DIR="$ADDONSDIR/metamod"

# Download and install SourceMod (Latest from 1.13 branch)
# Using -L flag to follow symlinks to the actual file
if [[ ! -d "$SM_DIR" ]]; then
  echo "Downloading SourceMod from https://sm.alliedmods.net/smdrop/1.13/sourcemod-latest-linux..."
  cd /tmp
  
  # Download with -L to follow symlinks
  if wget -L --timeout=30 "https://sm.alliedmods.net/smdrop/1.13/sourcemod-latest-linux" -O sourcemod.tar.gz 2>&1; then
    echo "Download completed, checking file..."
    if [[ -f sourcemod.tar.gz ]] && [[ -s sourcemod.tar.gz ]]; then
      echo "Extracting SourceMod..."
      if tar -xzf sourcemod.tar.gz -C "$ADDONSDIR" 2>&1; then
        rm sourcemod.tar.gz
        echo "✓ SourceMod installed successfully"
        ls -la "$SM_DIR" 2>/dev/null | head -10
      else
        echo "✗ Failed to extract SourceMod tarball"
        file sourcemod.tar.gz
      fi
    else
      echo "✗ Downloaded file is empty or not found"
      file sourcemod.tar.gz 2>&1 || echo "File does not exist"
    fi
  else
    echo "✗ Failed to download SourceMod (wget error)"
  fi
else
  echo "✓ SourceMod already installed"
  ls -la "$SM_DIR/bin" 2>/dev/null | head -5
fi

# Download and install MetaMod:Source (Latest from 2.0 branch)
if [[ ! -d "$MM_DIR" ]]; then
  echo "Downloading MetaMod:Source from https://mms.alliedmods.net/mmsdrop/2.0/mmsource-latest-linux..."
  cd /tmp
  
  # Download with -L to follow symlinks
  if wget -L --timeout=30 "https://mms.alliedmods.net/mmsdrop/2.0/mmsource-latest-linux" -O metamod.tar.gz 2>&1; then
    echo "Download completed, checking file..."
    if [[ -f metamod.tar.gz ]] && [[ -s metamod.tar.gz ]]; then
      echo "Extracting MetaMod:Source..."
      if tar -xzf metamod.tar.gz -C "$ADDONSDIR" 2>&1; then
        rm metamod.tar.gz
        echo "✓ MetaMod:Source installed successfully"
        ls -la "$MM_DIR" 2>/dev/null | head -10
      else
        echo "✗ Failed to extract MetaMod tarball"
        file metamod.tar.gz
      fi
    else
      echo "✗ Downloaded file is empty or not found"
      file metamod.tar.gz 2>&1 || echo "File does not exist"
    fi
  else
    echo "✗ Failed to download MetaMod:Source (wget error)"
  fi
else
  echo "✓ MetaMod:Source already installed"
  ls -la "$MM_DIR/bin" 2>/dev/null | head -5
fi

# Set proper permissions for addons
echo "Setting permissions on addons directory..."
chmod -R 755 "$ADDONSDIR" 2>&1 || echo "Warning: Could not set permissions (might be read-only mount)"

echo "=== Addons directory contents ==="
ls -la "$ADDONSDIR"
echo ""
if [[ -d "$SM_DIR" ]]; then
  echo "SourceMod contents:"
  ls -la "$SM_DIR" | head -15
fi
if [[ -d "$MM_DIR" ]]; then
  echo "MetaMod contents:"
  ls -la "$MM_DIR" | head -15
fi

# Copy SourceMod configuration files if they exist
echo "=== Setting up SourceMod configuration ==="
if [[ -d "$SM_DIR/configs" ]]; then
  echo "Copying SourceMod config files..."
  
  if [[ -f "/serverdata/sourcemod.cfg" ]]; then
    cp -v "/serverdata/sourcemod.cfg" "$SM_DIR/configs/sourcemod.cfg" && echo "✓ Copied sourcemod.cfg"
  fi
  
  if [[ -f "/serverdata/admins.cfg" ]]; then
    cp -v "/serverdata/admins.cfg" "$SM_DIR/configs/admins.cfg" && echo "✓ Copied admins.cfg"
  fi
  
  # Fix permissions
  chmod 644 "$SM_DIR/configs/"*.cfg 2>/dev/null
  echo "Config files ready"
else
  echo "Warning: SourceMod configs directory not found"
fi

echo "=== Proceeding with original entrypoint ==="
echo ""

# Execute the original entrypoint from the image
# The ich777 image uses /opt/scripts/start.sh as entrypoint
exec /opt/scripts/start.sh "$@"
