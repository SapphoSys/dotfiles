{ config, pkgs, ... }:

{
  age.secrets.caddy_env = {
    file = ../secrets/caddy.env.age;
    mode = "600";
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-XwZ0Hkeh2FpQL/fInaSq+/3rCLmQRVvwBM0Y1G1FZNU=";
    };
    environmentFile = config.age.secrets.caddy_env.path;
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

  systemd.services.caddy = {
    serviceConfig = {
      EnvironmentFile = config.age.secrets.caddy_env.path;
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];
}
