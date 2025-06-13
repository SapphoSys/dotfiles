{ pkgs, lib, osConfig }:

lib.optionals osConfig.settings.gui.enable (with pkgs; [
  # cloud
  owncloud-client

  # messengers
  telegram-desktop
  vesktop

  # notes
  obsidian

  # kde theme override
  (catppuccin-kde.override {
    flavour   = [ "mocha" ];
    accents   = [ "pink" ];
    winDecStyles = [ "classic" ];
  })

  # fonts
  iosevka
  inter
  atkinson-hyperlegible
  nerd-fonts.jetbrains-mono

  # dev tools
  bun
  jetbrains.webstorm
  jetbrains.idea-ultimate
  jetbrains.pycharm-professional
  jetbrains.rider
  jetbrains.datagrip
  zed-editor
  httpie-desktop

  # mail
  thunderbird

  # games
  prismlauncher

  # other GUI apps
  kdePackages.akregator
  obs-studio
  miru
])
