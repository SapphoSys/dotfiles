{
  services.adguardhome = {
    enable = true;
    host = "localhost";
    port = 3000;
    settings = {
      dns = {
        port = 53;
        port_tls = 853;
        port_https = 8443;
        port_quic = 784;
      };
    };
  };

  settings.firewall = {
    allowedTCPPorts = [
      8443
      3000
    ];
    allowedUDPPorts = [
      53
      784
    ];
  };
}
