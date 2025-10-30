{
  imports = [
    ./hardware.nix
  ];

  settings = {
    bootloader.grub = {
      enable = true;
      device = "/dev/vda";
    };

    profiles.server.enable = true;
  };

  system.stateVersion = "25.05";
}
