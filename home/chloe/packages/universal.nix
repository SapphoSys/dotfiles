{
  pkgs,
  lib,
  osConfig,
}:

let
  packages = with pkgs; [
    # dev tools
    zed-editor

    # fonts
    iosevka
    inter
    atkinson-hyperlegible
    nerd-fonts.jetbrains-mono

    # games
    prismlauncher

    # notes
    obsidian
  ];
in
lib.optionals osConfig.settings.profiles.graphical.enable packages
