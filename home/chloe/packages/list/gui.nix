{ pkgs, lib, osConfig }:

let
  # Common GUI packages available on all platforms
  commonPackages = with pkgs; [
    # cloud
    owncloud-client

    # messengers
    telegram-desktop
    vesktop

    # notes
    obsidian

    # dev tools
    zed-editor
    httpie-desktop

    # mail
    thunderbird

    # games
    prismlauncher
    xivlauncher

    # other GUI apps
    obs-studio
    _1password-gui
  ];
in lib.optionals osConfig.settings.profiles.graphical.enable commonPackages
