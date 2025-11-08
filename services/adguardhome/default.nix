{
  services.adguardhome = {
    enable = true;
    host = "0.0.0.0";
    port = 80;
    settings = {
      dns = {
        port = 53;
        port_tls = 853;
        port_https = 443;
        port_quic = 784;
      };

      web_port = 3000;
    };
  };

  settings.firewall = {
    allowedTCPPorts = [
      80
      443
      3000
    ];
    allowedUDPPorts = [
      53
      784
    ];
  };
}
