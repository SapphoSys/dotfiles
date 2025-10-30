{
  imports = [
    ./hardware.nix
  ];

  settings = {
    bootloader.grub = {
      enable = true;
      device = "/dev/vda";
    };

    profiles = {
      headless.enable = true;
      server.enable = true;
    };
  };

  system.stateVersion = "25.05";
}
