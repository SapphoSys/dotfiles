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
  zed-editor
  httpie-desktop

  # mail
  thunderbird

  # games
  prismlauncher
  xivlauncher

  # other GUI apps
  kdePackages.akregator
  obs-studio
  miru
])
