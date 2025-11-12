{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.settings.firewall = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable firewall";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.iptables;
      description = "Firewall package to use";
    };

    allowedTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
      description = "Allowed TCP ports";
    };

    allowedUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
      description = "Allowed UDP ports";
    };
  };

  config = lib.mkIf config.settings.firewall.enable {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = config.settings.firewall.allowedTCPPorts;
      allowedUDPPorts = config.settings.firewall.allowedUDPPorts;
      logRefusedConnections = lib.mkDefault false;
      logRefusedPackets = lib.mkDefault false;
    };

    networking.firewall.allowedTCPPortsIPv6 = config.settings.firewall.allowedTCPPorts;
    networking.firewall.allowedUDPPortsIPv6 = config.settings.firewall.allowedUDPPorts;
  };
}
