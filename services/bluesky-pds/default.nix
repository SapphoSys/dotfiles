{ config, lib, ... }:

{
  age.secrets.bluesky-pds = {
    file = ../../secrets/bluesky-pds.age;
    owner = "pds";
    group = "pds";
    mode = "600";
  };

  services.bluesky-pds = {
    enable = true;
    pdsadmin.enable = true;
    settings = {
      PDS_HOSTNAME = "pds.sappho.systems";
      PDS_PORT = 3333;
      PDS_CRAWLERS = lib.concatStringsSep "," [
        "https://bsky.network"
        "https://relay.cerulea.blue"
        "https://relay.upcloud.world"
        "https://atproto.africa"
      ];
    };
    environmentFiles = [ config.age.secrets.bluesky-pds.path ];
  };

  services.caddy.virtualHosts."pds.sappho.systems" = {
    serverAliases = [ "*.pds.sappho.systems" ];
    extraConfig = ''
      import common
      import tls_cloudflare
      reverse_proxy http://127.0.0.1:3333
    '';
  };
}
