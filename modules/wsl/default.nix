{
  imports = [
    ../../home
    ./extras.nix
    ./packages.nix
  ];

  config = {
    wsl = {
      enable = true;
      defaultUser = "chloe";
    };
    
    # Allow opening files and links in Windows from WSL
    environment.variable.BROWSER = "wsl-open";
  };
}