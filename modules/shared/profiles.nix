{ lib, ... }:

{
  options.settings = {
    profiles = {
      graphical.enable = lib.mkEnableOption "Graphical interface";
      laptop.enable = lib.mkEnableOption "Laptop";
    };
    
    desktop.kde.enable = lib.mkEnableOption "Enable KDE Plasma desktop environment";
  };
}
