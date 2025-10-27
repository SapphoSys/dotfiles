{ lib, config, types, ... }:

{
  options.hardware.bluetooth.enable = {
    type = types.bool;
    default = lib.mkIf lib.stdenv.hostPlatform.isLinux true false;
    description = ''
      Enable Bluetooth support.
    '';
  };

  config = {
    hardware.bluetooth.enable = lib.mkIf config.hardware.bluetooth.enable;
  };
}