{
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  basePackages = import ./base.nix { inherit pkgs; };
  darwinPackages = import ./darwin.nix { inherit pkgs lib osConfig; };
  linuxPackages = import ./linux.nix { inherit pkgs lib osConfig; };
  universalPackages = import ./universal.nix { inherit pkgs lib osConfig; };
in
{
  config = {
    home.packages = basePackages ++ darwinPackages ++ linuxPackages ++ universalPackages;
  };
}
