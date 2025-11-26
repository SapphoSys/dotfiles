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
      "${./entrypoint.sh}:/entrypoint.sh:ro"
    ];

    # Use custom entrypoint to set up SDK before server starts
    cmd = [ "/entrypoint.sh" ];

    extraOptions = [
      "--restart=always"
      "--entrypoint=/bin/bash"
    ];
  };

  # Post-startup hook to configure RCON password
  systemd.services.hl2dm-configure = {
    after = [ "podman-hl2dm.service" ];
    wantedBy = [ "multi-user.target" ];
    requires = [ "podman-hl2dm.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    script = ''
      echo "Starting HL2DM configuration..."
      sleep 5

      # Create server_local.cfg with RCON password if it doesn't exist
      LOCALCFG="/var/lib/hl2dm/serverfiles/hl2mp/cfg/server_local.cfg"
      SERVERCFG="/var/lib/hl2dm/serverfiles/hl2mp/cfg/server.cfg"

      echo "Checking for $LOCALCFG"

      if [[ ! -f "$LOCALCFG" ]]; then
        echo "Creating server_local.cfg..."
        RCON_PASS=$(cat ${config.age.secrets.hl2dm-rcon.path})
        echo "// Local server configuration (not managed by NixOS)" > "$LOCALCFG"
        echo "rcon_password \"$RCON_PASS\"" >> "$LOCALCFG"
        echo "sv_password \"\"" >> "$LOCALCFG"
        echo "hostname \"Chloe's Half-Life 2 Deathmatch Server\"" >> "$LOCALCFG"
        chmod 644 "$LOCALCFG"
        echo "✓ RCON password configured in server_local.cfg"
      else
        echo "✓ server_local.cfg already exists"
      fi

      # Ensure server_local.cfg is executed by server.cfg
      if ! grep -q "exec.*server_local.cfg" "$SERVERCFG"; then
        echo ""
        echo "Adding server_local.cfg execution to server.cfg..."
        echo "" >> "$SERVERCFG"
        echo "// Execute local server configuration" >> "$SERVERCFG"
        echo "exec server_local.cfg" >> "$SERVERCFG"
        echo "✓ Added exec server_local.cfg to server.cfg"
      else
        echo "✓ server_local.cfg already executed in server.cfg"
      fi

      ls -la "$LOCALCFG"
    '';
  };

  # Firewall configuration for game server
  settings.firewall.allowedUDPPorts = [ 27015 ];
  settings.firewall.allowedTCPPorts = [ 27015 ];
}
