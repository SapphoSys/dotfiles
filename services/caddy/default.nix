{ config, pkgs, ... }:

{
  age.secrets.caddy = {
    file = ../../secrets/caddy.age;
    mode = "600";
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/bunny@v1.2.0" ];
      hash = "sha256-bwffi5sWq07DVoPQGgEIN1jnvQKL6c4tFfR9AT9ThD4=";
    };
    environmentFile = config.age.secrets.caddy.path;
    globalConfig = ''
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
