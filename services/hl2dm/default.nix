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
    };

    hl2dm-server = {
      file = ../../secrets/hl2dm-server.age;
      mode = "600";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/srcds 0755 srcds srcds -"
    "d /var/lib/srcds/.local 0755 srcds srcds -"
    "d /var/lib/srcds/.local/share 0755 srcds srcds -"
    "d /var/lib/srcds/.local/share/Steam 0755 srcds srcds -"
    "d /var/lib/srcds/.local/share/Steam/ubuntu12_32 0755 srcds srcds -"
  ];

  systemd.services.srcds-setup = {
    preStart = lib.mkBefore ''
      # Work around bug in srcds-nix tar extraction
      # Pre-extract the Steam bootstrap to avoid "tar -C $STEAMDIR -xvf $STEAMDIR" failing
      if [[ ! -d /var/lib/srcds/.local/share/Steam/ubuntu12_32 ]] || [[ ! -f /var/lib/srcds/.local/share/Steam/ubuntu12_32/steam-runtime/run.sh ]]; then
        STEAMDIR=/var/lib/srcds/.local/share/Steam
        mkdir -p $STEAMDIR
        ${pkgs.steam-unwrapped}/bin/steam-runtime-launcher-system setup "$STEAMDIR/ubuntu12_32" 2>/dev/null || true
      fi
    '';
  };

  services.srcds = {
    enable = true;
    openFirewall = true;

    games.my-hl2dm-server = {
      appId = 232370;
      gamePort = 27015;

      rcon = {
        enable = true;
        password = config.age.secrets.hl2dm-rcon.path;
      };

      serverConfig = {
        hostname = "Chloe's HL2DM server on NixOS";
        sv_contact = "chloe@sapphic.moe";
        sv_password = config.age.secrets.hl2dm-server.path;
      };
    };
  };

  settings.firewall.allowedUDPPorts = [ 27015 ];
}
