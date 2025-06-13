{
  lib,
  osConfig,
  pkgs,
  inputs,
  ...
}:
{
  config = lib.mkIf osConfig.settings.gui.enable {
    # home.packages = [
    #   inputs.self.packages.${pkgs.system}.cider
    # ];
  };
}
