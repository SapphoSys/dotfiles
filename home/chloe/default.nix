{
  imports = [
    ./activation.nix
    ./autostart.nix
    ./catppuccin.nix
    ./docs.nix
    ./files.nix
    ./packages
    ./programs
    ./scripts.nix
  ];

  xdg.enable = true;

  # Font configuration
  fonts.fontconfig.enable = true;
}
