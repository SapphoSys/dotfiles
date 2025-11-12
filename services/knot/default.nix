{
  services.tangled-knot = {
    enable = true;
    motd = ''
      🌸 welcome to the tangled knot server 🌸

      hosted by sapphic angels
    '';
    server = {
      hostname = "knot.sappho.systems";
      owner = "did:plc:ucaezectmpny7l42baeyooxi";
    };
  };

  services.caddy.virtualHosts."knot.sappho.systems" = {
    extraConfig = ''
      import common
      import tls_cloudflare
      reverse_proxy http://127.0.0.1:5555
    '';
  };

  settings.firewall.allowedTCPPorts = [ 22 ];
}
