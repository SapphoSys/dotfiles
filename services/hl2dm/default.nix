{ config, ... }:

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

  services.srcds = {
    enable = true;
    openFirewall = true;

    games.my-hl2dm-server = {
      appId = 232370;
      gamePort = 27015;

      rcon = {
        enable = true;
        password = config.age.secrets.hl2dm.path;
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
