{ config, ... }:

{
  # Redis service (new style)
  services.redis.servers."lanyard" = {
    enable = true;
    port = 6379;
    bind = "127.0.0.1";
  };

  # Age secret for Discord bot token
  age.secrets.lanyard = {
    file = ../../secrets/lanyard.age;
    mode = "600";
  };

  # Lanyard Docker container
  virtualisation.oci-containers.containers.lanyard = {
    image = "phineas/lanyard:latest";
    ports = [ "4001:4001" ];
    environment = {
      REDIS_HOST = "localhost";
    };
    environmentFiles = [ config.age.secrets.lanyard.path ];
    autoRemoveOnStop = false;
    extraOptions = [ "--restart=always" ];
  };

  services.caddy.virtualHosts."lanyard.sappho.systems" = {
    listenAddresses = [ "::" ];
    extraConfig = ''
      import common
      import tls_cloudflare
      reverse_proxy http://127.0.0.1:4001
    '';
  };
}
