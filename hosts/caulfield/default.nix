{
  imports = [
    ./hardware.nix
  ];

  settings = {
    desktop = {
      kde.enable = true;
    };

    hardware = {
      audio.enable = true;
      nvidia.enable = true;
    };

    profiles = {
      graphical.enable = true;
      laptop.enable = true;
    };

    software = {
      solaar.enable = true;
    };

    virtualization = {
      waydroid.enable = true;
    };
  };

  system.stateVersion = "23.11"; # Initial NixOS version
}
