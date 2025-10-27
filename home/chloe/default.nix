{
  imports = [
    ./catppuccin.nix
    ./docs.nix
    ./files.nix
    ./packages
    ./programs
  ];

  xdg.enable = true;

  # Font configuration
  fonts.fontconfig.enable = true;
}
