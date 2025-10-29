{
  imports = [
    ./hardware.nix
  ];

  virtualisation.waydroid.enable = true;

  settings = {
    desktop.kde.enable = true;

    bootloader.enable = true;
    solaar.enable = true;

    profiles = {
      graphical.enable = true;
      laptop.enable = true;
    };

    hardware = {
      audio.enable = true;
      nvidia.enable = true;
    };
  };

  system.stateVersion = "23.11"; # Initial NixOS version
}
