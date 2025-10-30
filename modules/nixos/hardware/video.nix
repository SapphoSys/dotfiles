{ lib, config, ... }:

{
  config = lib.mkIf config.settings.profiles.graphical.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
