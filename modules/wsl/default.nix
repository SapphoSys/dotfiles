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
    
    # Allow opening files and links in Windows from WSL
    environment.variables.BROWSER = "wsl-open";
  };
}
