{
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
    unmanaged = [
      "interface-name:tailscale*"
      "interface-name:docker*"
      "interface-name:waydroid*"
      "type:bridge"
    ];
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}