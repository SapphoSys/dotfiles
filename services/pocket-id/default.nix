{ config, ... }:

{
  age.secrets.pocket-id = {
    file = ../../secrets/pocket-id.age;
    mode = "600";
    owner = "pocket-id";
    group = "pocket-id";
  };

  services.pocket-id = {
    enable = true;
    environmentFile = config.age.secrets.pocket-id.path;

    settings = {
      APP_URL = "https://id.sappho.systems";
      TRUST_PROXY = true;
    };
  };

  services.caddy.virtualHosts."id.sappho.systems" = {
    extraConfig = ''
      import common
      import tls_bunny
      reverse_proxy http://localhost:1411
    '';
  };
}
