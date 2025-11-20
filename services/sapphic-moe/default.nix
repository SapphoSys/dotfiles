{ config, ... }:

{
  age.secrets.sapphic-moe = {
    file = ../../secrets/sapphic-moe.age;
    mode = "600";
  };

  age.secrets.ghcr-io-token = {
    file = ../../secrets/ghcr-io-token.age;
    mode = "600";
    owner = "root";
    group = "root";
  };

  # Configure podman authentication for ghcr.io
  system.activationScripts.podman-ghcr-auth = {
    text = ''
      mkdir -p /root/.config/containers
      cat > /root/.config/containers/auth.json <<EOF
      {
        "auths": {
          "ghcr.io": {
            "auth": "$(echo -n "_:$(cat ${config.age.secrets.ghcr-io-token.path})" | base64 -w0)"
          }
        }
      }
      EOF
      chmod 600 /root/.config/containers/auth.json
    '';
    deps = [ "agenix" ];
  };

  virtualisation.oci-containers.containers.sapphic-moe = {
    image = "ghcr.io/sapphosys/sapphic-moe:latest";
    pull = "always";

    ports = [ "3000:4321" ];

    environment = {
      NODE_ENV = "production";
      ASTRO_TELEMETRY_DISABLED = "1";
      NPM_CONFIG_UPDATE_NOTIFIER = "false";
    };

    environmentFiles = [ config.age.secrets.sapphic-moe.path ];

    autoRemoveOnStop = false;

    extraOptions = [
      "--restart=always"
      "--network=host"
    ];
  };

  services.caddy.virtualHosts."sapphic.moe" = {
    extraConfig = ''
      import common
      import tls_bunny
      reverse_proxy http://127.0.0.1:3000
    '';
  };
}
