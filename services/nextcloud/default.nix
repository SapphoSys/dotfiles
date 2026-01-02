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

  services.caddy.virtualHosts."nc.sappho.systems" = {
    extraConfig = ''
      import common
      import tls_bunny
      reverse_proxy http://localhost:7070
    '';
  };
}
