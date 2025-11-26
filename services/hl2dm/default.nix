{
  config,
  lib,
  pkgs,
  ...
}:

{
  age.secrets = {
    hl2dm-rcon = {
      file = ../../secrets/hl2dm-rcon.age;
      mode = "600";
      owner = "srcds";
      group = "srcds";
    };

    hl2dm-server = {
      file = ../../secrets/hl2dm-server.age;
      mode = "600";
      owner = "srcds";
      group = "srcds";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/srcds 0755 srcds srcds -"
    "d /var/lib/srcds/.local 0755 srcds srcds -"
    "d /var/lib/srcds/.local/share 0755 srcds srcds -"
    "d /var/lib/srcds/.local/share/Steam 0755 srcds srcds -"
    "d /var/lib/srcds/.local/share/Steam/ubuntu12_32 0755 srcds srcds -"
    "d /var/lib/srcds/.steam 0755 srcds srcds -"
    "d /var/lib/srcds/.steam/sdk32 0755 srcds srcds -"
    "d /var/lib/srcds/my-hl2dm-server 0755 srcds srcds -"
    "d /var/lib/srcds/my-hl2dm-server/hl2mp 0755 srcds srcds -"
  ];

  systemd.services.srcds-setup = {
    path = [
      pkgs.gnutar
      pkgs.xz
      pkgs.steamcmd
    ];

    preStart = lib.mkBefore ''
      # Work around bug in srcds-nix tar extraction
      # Pre-extract the Steam bootstrap to avoid "tar -C $STEAMDIR -xvf $STEAMDIR" failing
      STEAMDIR=/var/lib/srcds/.local/share/Steam
      mkdir -p $STEAMDIR

      if [[ ! -f $STEAMDIR/ubuntu12_32/steam-runtime/run.sh ]]; then
        echo "Setting up Steam runtime..."
        # Extract bootstrap directly from steam-unwrapped
        if [[ -f ${pkgs.steam-unwrapped}/lib/steam/bootstraplinux_ubuntu12_32.tar.xz ]]; then
          echo "Extracting Steam runtime from steam-unwrapped..."
          tar -C $STEAMDIR -xf ${pkgs.steam-unwrapped}/lib/steam/bootstraplinux_ubuntu12_32.tar.xz || true
        fi
      fi

      if [[ ! -f $STEAMDIR/ubuntu12_32/steam-runtime/run.sh ]]; then
        echo "WARNING: Steam runtime not found at $STEAMDIR/ubuntu12_32/steam-runtime/run.sh"
      else
        echo "Steam runtime ready at $STEAMDIR/ubuntu12_32/steam-runtime/run.sh"
      fi

      # Set up Steam SDK files to avoid runtime errors
      echo "Setting up Steam SDK files..."
      SDKDIR=/var/lib/srcds/.steam/sdk32
      mkdir -p $SDKDIR
      if [[ -f ${pkgs.steam-unwrapped}/lib/steam/steamclient.so ]]; then
        cp -f ${pkgs.steam-unwrapped}/lib/steam/steamclient.so $SDKDIR/steamclient.so || true
      fi
      if [[ -f ${pkgs.steam-unwrapped}/lib/steam/steamclient32.so ]]; then
        cp -f ${pkgs.steam-unwrapped}/lib/steam/steamclient32.so $SDKDIR/steamclient32.so || true
      fi
      if [[ -f ${pkgs.steam-unwrapped}/lib/steam/linux32/steamclient.so ]]; then
        cp -f ${pkgs.steam-unwrapped}/lib/steam/linux32/steamclient.so $SDKDIR/steamclient.so || true
      fi

      # Initialize steamcmd to ensure Steam SDK is properly set up
      echo "Initializing Steam SDK..."
      HOME=/var/lib/srcds steamcmd +exit 2>/dev/null || true
      sleep 2

      # Try to bootstrap HL2DM server files
      if [[ ! -f /var/lib/srcds/my-hl2dm-server/hl2mp/srcds_run ]]; then
        echo "Attempting to download HL2DM server files..."
        HOME=/var/lib/srcds steamcmd \
          +force_install_dir /var/lib/srcds/my-hl2dm-server \
          +login anonymous \
          +app_update 232370 validate \
          +exit || echo "SteamCMD download attempt completed (may have failed due to licensing)"
      fi
    '';
  };

  systemd.services."srcds-game-my-hl2dm-server" = {
    postStart = lib.mkBefore ''
      # Give Steam time to fully initialize before accepting connections
      echo "Waiting for Steam API initialization..."
      sleep 5
    '';
  };

  services.srcds = {
    enable = true;
    openFirewall = true;

    games.my-hl2dm-server = {
      appId = 232370;
      autoUpdate = false;
      gamePort = 27015;
      startingMap = "dm_powerhouse";

      rcon = {
        enable = true;
        password = config.age.secrets.hl2dm-rcon.path;
      };

      serverConfig = {
        hostname = "Chloe's Half-Life 2 Deathmatch server on NixOS";
      };

      extraArgs = [
        "+sv_hibernate_when_empty 0"
        "+net_start_thread 1"
      ];
    };
  };

  settings.firewall.allowedUDPPorts = [ 27015 ];
}
