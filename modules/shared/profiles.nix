{ lib, ... }:

{
  options.settings = {
    profiles = {
      graphical.enable = lib.mkEnableOption "Graphical interface";
      laptop.enable = lib.mkEnableOption "Laptop";
      server.enable = lib.mkEnableOption "Server configuration";
    };
    
    desktop.kde.enable = lib.mkEnableOption "Enable KDE Plasma desktop environment";
  };
}
