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
        "github.com/mholt/caddy-l4@v0.0.0-20251124224044-66170bec9f4d"
      ];
      hash = "sha256-R8o6ESYpFvTPgW0ZOEQ7G06by8yp5AwPJpmJYFOeX0A=";
    };
    environmentFile = config.age.secrets.caddy.path;
    globalConfig = ''
      debug
      email chloe@sapphic.moe
      
      layer4 {
        0.0.0.0:27015 {
          route {
            proxy localhost:27016
          }
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
    '';
    logFormat = ''
      level debug
      format json
    '';
  };

  settings.firewall.allowedTCPPorts = [
    80
    443
    27015
  ];

  settings.firewall.allowedUDPPorts = [
    443
    27015
  ];
}
