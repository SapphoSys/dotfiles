{
  imports = [
    ./extras.nix
    ../nixos
    ./packages.nix
  ];

  config = {
    wsl = {
      enable = true;
      defaultUser = "chloe";
    };

    # Windows manages the firewall for us.
    settings.firewall.enable = false;
    
    # Allow opening files and links in Windows from WSL
    environment.variables.BROWSER = "wsl-open";
  };
}
