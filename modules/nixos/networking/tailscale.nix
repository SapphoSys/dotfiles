# From https://github.com/isabelroses/dotfiles/blob/main/modules/nixos/networking/tailscale.nix

{ lib, config, ... }:

{
  options = {
    settings.tailscale = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Tailscale VPN client/service";
      };

      defaultFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "--ssh" ];
        description = "A list of command-line flags that will be passed to the Tailscale daemon";
      };

      isServer = lib.mkOption {
        type = lib.types.bool;
        default = config.settings.profiles.server.enable;
        description = "Whether this Tailscale instance is a server/relay node";
      };

      isClient = lib.mkOption {
        type = lib.types.bool;
        default = config.settings.tailscale.enable && !config.settings.tailscale.isServer;
        description = "Whether this Tailscale instance is a client";
      };
    };
  };

  config = lib.mkIf config.settings.tailscale.enable {
    settings.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

    networking.firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      checkReversePath = false;
    };

    services.tailscale = {
      enable = true;
      permitCertUid = "root";
      useRoutingFeatures = lib.mkDefault "server";
      extraUpFlags =
        config.settings.tailscale.defaultFlags
        ++ lib.optionals config.settings.tailscale.isServer [ "--advertise-exit-node" ];
    };

    # A server cannot be a client and vice versa
    assertions = [
      {
        assertion = config.settings.tailscale.isClient != config.settings.tailscale.isServer;
        message = "Tailscale instance cannot be both a client and a server at the same time.";
      }
    ];
  };
}
