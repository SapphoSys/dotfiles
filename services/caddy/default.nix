{ config, pkgs, ... }:

{
  age.secrets.caddy = {
    file = ../../secrets/caddy.age;
    mode = "600";
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/caddy-dns/bunny@v1.2.0"
        "github.com/digilolnet/caddy-bunny-ip@v0.0.0-20250118080727-ef607b8e1644"
      ];
      hash = "sha256-j82fgKbh8AcM9jbKUoRKQsAvF/xaUj3pZLdAr9QtST0=";
    };
    environmentFile = config.age.secrets.caddy.path;
    globalConfig = ''
      email chloe@sapphic.moe
      servers {
        trusted_proxies bunny {
          interval 6h
          timeout 25s
        }
      }
    '';
    extraConfig = ''
      (tls_bunny) {
        tls {
          dns bunny {env.BUNNY_API_KEY}
          resolvers 9.9.9.9 149.112.112.112
        }
      }

      (common) {
        encode zstd gzip
      }

      (deny_non_bunny) {
        @not_bunny not client_ip 127.0.0.1 ::1
        handle @not_bunny {
          abort
        }
      }
    '';
    logFormat = ''
      level info
      format json
    '';
  };

  settings.firewall.allowedTCPPorts = [
    80
    443
  ];

  settings.firewall.allowedUDPPorts = [ 443 ];
}
