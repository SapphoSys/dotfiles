{
  services.glance = {
    enable = true;
    openFirewall = true;
    settings = import ./settings.nix;
  };

  services.caddy.virtualHosts."home.sappho.systems" = {
    listenAddresses = [ "::" ];
    extraConfig = ''
      import common
      import tls_cloudflare
      reverse_proxy http://localhost:4040
    '';
  };
}
