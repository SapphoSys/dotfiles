{
  imports = [
    ./hardware.nix
  ];

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  settings = {
    bootloader.enable = true;
    gui.enable = true;
    kde.enable = true;
    solaar.enable = true;

    hardware = {
      nvidia.enable = true;
      asus.enable = true;
      audio.enable = true;
    };
  };

  system.stateVersion = "23.11"; # Initial NixOS version
}
