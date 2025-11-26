#!/bin/bash
# Custom entrypoint for HL2DM container
# Sets up SDK files before game server starts

echo "=== HL2DM SDK Setup ==="

# Wait for steamcmd to complete initial setup
sleep 3

SDKDIR="/serverdata/.steam/sdk32"
STEAMCMDDIR="/serverdata/steamcmd/linux32"

echo "SDK directory: $SDKDIR"
echo "SteamCMD directory: $STEAMCMDDIR"

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

echo "=== Proceeding with original entrypoint ==="
echo ""

# Execute the original entrypoint from the image
# The ich777 image uses /opt/scripts/start.sh as entrypoint
exec /opt/scripts/start.sh "$@"
