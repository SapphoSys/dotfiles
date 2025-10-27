{ inputs, lib, pkgs, osConfig, ... }:

{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin = {
    enable = true;
    accent = "pink";
    flavor = "mocha";
  };

  # KDE-specific catppuccin package
  home.packages = lib.optionals (osConfig.settings.desktop.kde.enable) [
    (pkgs.catppuccin-kde.override {
      flavour   = [ "mocha" ];
      accents   = [ "pink" ];
      winDecStyles = [ "classic" ];
    })
  ];
}
