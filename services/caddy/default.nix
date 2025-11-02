{ config, pkgs, ... }:

{
  age.secrets.caddy = {
    file = ../../secrets/caddy.age;
    mode = "600";
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-iRzpN9awuEFsc7hqKzOMNiCFFEv833xhd4LM+VFQedI=";
    };
    environmentFile = config.age.secrets.caddy.path;
    globalConfig = ''
      email chloe@sapphic.moe
    '';
    extraConfig = ''
      (tls_cloudflare) {
        tls {
          dns cloudflare {env.CF_API_TOKEN}
          resolvers 8.8.8.8 1.1.1.1
        }
      }
      (common) {
        encode zstd gzip
      }
    '';
  };

  settings.firewall.allowedTCPPorts = [
    80
    443
  ];

  settings.firewall.allowedUDPPorts = [ 443 ];
}
