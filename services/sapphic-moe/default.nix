{
  config,
  lib,
  pkgs,
  ...
}:

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

  # Set up podman authentication before container starts
  systemd.services.podman-sapphic-moe-setup = {
    description = "Setup podman authentication for sapphic-moe";
    before = [ "podman-sapphic-moe.service" ];
    requiredBy = [ "podman-sapphic-moe.service" ];
    after = [ "agenix.target" ];
    wantedBy = [ "multi-user.target" ];

    script = ''
      TOKEN=$(cat ${config.age.secrets.ghcr-io-token.path})
      ${pkgs.podman}/bin/podman login --username "_" --password-stdin ghcr.io <<< "$TOKEN"
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
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
      "--authfile=/root/.config/containers/auth.json"
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
