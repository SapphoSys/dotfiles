{
  config,
  ...
}:

{
  age.secrets = {
    hl2dm-rcon = {
      file = ../../secrets/hl2dm-rcon.age;
      mode = "600";
    };

    hl2dm-server = {
      file = ../../secrets/hl2dm-server.age;
      mode = "600";
    };
  };

  # Create data directories for persistent server files and configuration
  systemd.tmpfiles.rules = [
    "d /var/lib/hl2dm 0755 root root -"
    "d /var/lib/hl2dm/steamcmd 0755 root root -"
    "d /var/lib/hl2dm/serverfiles 0755 root root -"
    "d /var/lib/hl2dm/serverfiles/hl2mp 0755 root root -"
    "d /var/lib/hl2dm/serverfiles/hl2mp/cfg 0755 root root -"
    "d /var/lib/hl2dm/.steam 0755 root root -"
    "d /var/lib/hl2dm/.steam/sdk32 0755 root root -"
    "d /var/lib/hl2dm/Steam 0755 root root -"
  ];

  # Container-based HL2DM server using ich777's steamcmd docker image
  virtualisation.oci-containers.containers.hl2dm = {
    image = "ich777/steamcmd:hl2dm";
    autoStart = true;
    autoRemoveOnStop = false;
    ports = [
      "27015:27015/udp"
      "27015:27015/tcp"
    ];

    environment = {
      GAME_ID = "232370";
      GAME_NAME = "hl2mp";
      GAME_PORT = "27015";
      GAME_PARAMS = "+maxplayers 24 +map dm_lockdown";
      UID = "99";
      GID = "100";
    };

    # Mount volumes for persistent server files
    volumes = [
      "/var/lib/hl2dm/steamcmd:/serverdata/steamcmd"
      "/var/lib/hl2dm/serverfiles:/serverdata/serverfiles"
      "/var/lib/hl2dm/.steam:/serverdata/.steam"
      "/var/lib/hl2dm/Steam:/serverdata/Steam"
    ];

    extraOptions = [
      "--restart=always"
    ];
  };

  # Post-startup: Copy Steam SDK files from steamcmd to SDK directory
  systemd.services.hl2dm-sdk-init = {
    after = [ "hl2dm.service" ];
    wantedBy = [ "multi-user.target" ];
    requires = [ "hl2dm.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      sleep 5

      # Copy Steam SDK files - try multiple locations
      SDKDIR="/var/lib/hl2dm/.steam/sdk32"
      STEAMDIR="/var/lib/hl2dm/Steam"

      echo "Looking for steamclient.so in Steam directory..."
      find "$STEAMDIR" -name "steamclient.so*" 2>/dev/null | head -10

      # Find and copy any steamclient.so
      if [[ -f "$STEAMDIR/linux32/steamclient.so" ]]; then
        echo "Found: $STEAMDIR/linux32/steamclient.so"
        cp -vf "$STEAMDIR/linux32/steamclient.so" "$SDKDIR/steamclient.so" 2>&1
      elif [[ -f "$STEAMDIR/steamclient.so" ]]; then
        echo "Found: $STEAMDIR/steamclient.so"
        cp -vf "$STEAMDIR/steamclient.so" "$SDKDIR/steamclient.so" 2>&1
      else
        echo "steamclient.so not found - extracting from Steam runtime..."
        # Try to extract from Steam runtime
        if [[ -d "$STEAMDIR/ubuntu12_32/steam-runtime" ]]; then
          find "$STEAMDIR/ubuntu12_32/steam-runtime" -name "steamclient.so*" -exec cp -vf {} "$SDKDIR/" \;
        fi
      fi

      ls -la "$SDKDIR/" 2>/dev/null || echo "SDK directory empty"

      # Only restart if we found the file
      if [[ -f "$SDKDIR/steamclient.so" ]]; then
        echo "SDK files ready, restarting server..."
        sleep 2
        systemctl restart podman-hl2dm.service || true
      else
        echo "Warning: steamclient.so still not found after copy attempt"
      fi
    '';
  };

  # Post-startup hook to configure RCON password
  systemd.services.hl2dm-configure = {
    after = [ "hl2dm.service" ];
    wantedBy = [ "multi-user.target" ];
    requires = [ "hl2dm.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      sleep 10

      # Create server_local.cfg with RCON password if it doesn't exist
      LOCALCFG="/var/lib/hl2dm/serverfiles/hl2mp/cfg/server_local.cfg"

      if [[ ! -f "$LOCALCFG" ]]; then
        RCON_PASS=$(cat ${config.age.secrets.hl2dm-rcon.path})
        echo "// Local server configuration (not managed by NixOS)" > "$LOCALCFG"
        echo "rcon_password \"$RCON_PASS\"" >> "$LOCALCFG"
        echo "sv_password \"\"" >> "$LOCALCFG"
        echo "hostname \"Chloe's Half-Life 2 Deathmatch Server\"" >> "$LOCALCFG"
        chmod 644 "$LOCALCFG"
        echo "RCON password configured in server_local.cfg"
      fi
    '';
  };

  # Debug service to find where steamclient.so actually is
  systemd.services.hl2dm-sdk-debug = {
    after = [ "hl2dm.service" ];
    wantedBy = [ ];
    requires = [ "hl2dm.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      sleep 3
      echo "=== HL2DM SDK Debug ==="
      echo "Steam directory contents:"
      find /var/lib/hl2dm/Steam -type f -name "*.so*" 2>/dev/null | head -20
      echo ""
      echo "Container Steam directory contents:"
      podman exec hl2dm find /serverdata/Steam -type f -name "*.so*" 2>/dev/null | head -20 || true
    '';
  };
}
