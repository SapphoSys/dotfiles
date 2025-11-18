{ config, ... }:

{
  services.redis.servers."lanyard" = {
    enable = true;
    port = 6379;
    bind = "127.0.0.1";
  };

  age.secrets.lanyard = {
    file = ../../secrets/lanyard.age;
    mode = "600";
  };

  virtualisation.oci-containers.containers.lanyard = {
    image = "phineas/lanyard:latest";
    ports = [ "4001:4001" ];
    environment = {
      REDIS_HOST = "127.0.0.1";
    };
    environmentFiles = [ config.age.secrets.lanyard.path ];
    autoRemoveOnStop = false;
    extraOptions = [
      "--restart=always"
      "--network=host"
    ];
  };

  services.caddy.virtualHosts."lanyard.sappho.systems" = {
    extraConfig = ''
      import common
      import tls_bunny
      reverse_proxy http://127.0.0.1:4001
    '';
  };
}
