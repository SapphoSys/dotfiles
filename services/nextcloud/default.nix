{ config, ... }:

{
  age.secrets.nextcloud = {
    file = ../../secrets/nextcloud.age;
    mode = "600";
  };

  services.nextcloud = {
    enable = true;
    hostName = "nc.sappho.systems";

    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks;
    };

    config = {
      adminpassFile = config.age.secrets.nextcloud.path;
      dbtype = "sqlite";
    };

    extraAppsEnable = true;
  };

  # Make nginx listen on 127.0.0.1:7070 for this vhost
  services.nginx.virtualHosts."nc.sappho.systems".listen = [
    {
      addr = "127.0.0.1";
      port = 7070;
    }
  ];

  services.caddy.virtualHosts."nc.sappho.systems" = {
    extraConfig = ''
      import common
      import tls_bunny
      reverse_proxy http://localhost:7070
    '';
  };
}
