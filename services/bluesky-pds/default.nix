{ config, ... }:

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
    };
    environmentFiles = [ config.age.secrets.bluesky-pds.path ];
  };

  services.caddy.virtualHosts."pds.sappho.systems" = {
    listenAddresses = [ "::" ];
    extraConfig = ''
      import common
      import tls_cloudflare
      reverse_proxy http://127.0.0.1:3333
    '';
  };

  services.caddy.virtualHosts."*.pds.sappho.systems" = {
    listenAddresses = [ "::" ];
    extraConfig = ''
      import common
      import tls_cloudflare
      reverse_proxy http://127.0.0.1:3333
    '';
  };

  settings.firewall.allowedTCPPorts = [ 3333 ];
}
