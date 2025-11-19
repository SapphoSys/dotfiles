{
  pkgs,
  lib,
  osConfig,
}:

let
  packages = with pkgs; [
    # tools
    shottr
  ];
in
lib.optionals (
  osConfig.settings.profiles.graphical.enable && pkgs.stdenv.hostPlatform.isDarwin
) packages
