{ pkgs, ... }:

{
  systemd.services.glance = {
    description = "Glance dashboard";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    reloadTriggers = [ "/etc/glance.yml" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.glance}/bin/glance --config /etc/glance.yml
      '';
      Restart = "always";
      RestartSec = 2;
    };
  };

  environment.etc."glance.yml".text = builtins.readFile ./glance.yml;
  networking.firewall.allowedTCPPorts = [ 4040 ];
}
