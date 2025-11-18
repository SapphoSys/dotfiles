{ config, ... }:

{
  age.secrets.glance = {
    file = ../../secrets/glance.age;
    mode = "600";
  };

  services.glance = {
    enable = true;
    openFirewall = true;
    environmentFile = config.age.secrets.glance.path;
    settings = import ./settings.nix;
  };

  services.caddy.virtualHosts."home.sappho.systems" = {
    extraConfig = ''
      import common
      import tls_bunny
      reverse_proxy http://localhost:4040
    '';
  };
}
