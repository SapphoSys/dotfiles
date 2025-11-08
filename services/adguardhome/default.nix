{
  services.adguardhome = {
    enable = true;
    # Data and config directories (persistent)
    dataDir = "/var/lib/adguardhome/work";
    configDir = "/var/lib/adguardhome/conf";
    # Open all required ports
    settings = {
      bind_port = 80;
      bind_host = "0.0.0.0";
      dns = {
        port = 53;
        port_tls = 853;
        port_https = 443;
        port_quic = 784;
      };
      web_port = 3000;
    };
    environment = {
      TZ = "UTC";
    };
    openFirewall = true;
    # Extra firewall ports for DHCP, etc.
    extraSettings = {
      firewall = {
        allowedTCPPorts = [
          53
          80
          443
          3000
          853
        ];
        allowedUDPPorts = [
          53
          67
          784
          853
        ];
      };
    };
  };
}
