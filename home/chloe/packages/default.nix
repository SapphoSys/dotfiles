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
    ./autostart.nix
    ./scripts.nix
  ];

  config = {
    home.packages = defaultPackages ++ guiPackages;
  };
}
