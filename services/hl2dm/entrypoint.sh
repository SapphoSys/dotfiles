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

# Download and install SourceMod (Latest from 1.13 branch)
SM_URL="https://sm.alliedmods.net/smdrop/1.13/sourcemod-latest-linux"
SM_DIR="$ADDONSDIR/sourcemod"
MM_DIR="$ADDONSDIR/metamod"

if [[ ! -d "$SM_DIR" ]]; then
  echo "Downloading SourceMod..."
  cd /tmp
  wget -q "$SM_URL" -O sourcemod.tar.gz
  
  if [[ -f sourcemod.tar.gz ]]; then
    echo "Extracting SourceMod..."
    tar -xzf sourcemod.tar.gz -C "$ADDONSDIR"
    rm sourcemod.tar.gz
    echo "✓ SourceMod installed successfully"
  else
    echo "✗ Failed to download SourceMod"
  fi
else
  echo "✓ SourceMod already installed"
fi

# Download and install MetaMod:Source (Latest from 2.0 branch)
if [[ ! -d "$MM_DIR" ]]; then
  echo "Downloading MetaMod:Source..."
  cd /tmp
  wget -q "https://mms.alliedmods.net/mmsdrop/2.0/mmsource-latest-linux" -O metamod.tar.gz
  
  if [[ -f metamod.tar.gz ]]; then
    echo "Extracting MetaMod:Source..."
    tar -xzf metamod.tar.gz -C "$ADDONSDIR"
    rm metamod.tar.gz
    echo "✓ MetaMod:Source installed successfully"
  else
    echo "✗ Failed to download MetaMod:Source"
  fi
else
  echo "✓ MetaMod:Source already installed"
fi

# Set proper permissions
chmod -R 755 "$ADDONSDIR"

echo "Addons directory contents:"
ls -la "$ADDONSDIR"

echo "=== Proceeding with original entrypoint ==="
echo ""

# Execute the original entrypoint from the image
# The ich777 image uses /opt/scripts/start.sh as entrypoint
exec /opt/scripts/start.sh "$@"
