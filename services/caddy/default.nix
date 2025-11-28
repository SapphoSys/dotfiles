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
        "github.com/mholt/caddy-l4@v0.0.0-20240815195819-06266cc7a7f2"
      ];
      hash = "sha256-LeLqz0LQyKwFekx7w9LJvv8Qj8W0Ol1RYKn0NZN3Txc=";
    };
    environmentFile = config.age.secrets.caddy.path;
    globalConfig = ''
      debug
      email chloe@sapphic.moe
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

  # Layer 4 (TCP/UDP) proxying for game servers
  services.caddy.layer4 = {
    servers.hl2dm-proxy = {
      listen = [ "0.0.0.0:27015" ];
      routes = [
        {
          handle = [
            {
              handler = "proxy";
              upstreams = [
                { dial = [ "localhost:27016" ]; }
              ];
            }
          ];
        }
      ];
    };
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
