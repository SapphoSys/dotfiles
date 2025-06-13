{ 
  pkgs,
  lib,
  osConfig, 
  ...
}:

let
  defaultPackages = import ./list/default.nix { inherit pkgs; };
  guiPackages = import ./list/gui.nix { inherit pkgs lib osConfig; };
in
{
  imports = [
    ./autostart.nix    # Apps that will run on boot
    ./custom.nix       # Custom packages
    ./scripts.nix      # Scripts
  ];

  config = {
    home.packages = defaultPackages ++ guiPackages;
  };
}
