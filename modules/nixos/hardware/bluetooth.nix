{
  lib,
  config,
  ...
}:

{
  options.hardware.bluetooth.enable = {
    type = lib.types.bool;
    default = lib.stdenv.hostPlatform.isLinux;
    description = "Enable Bluetooth support.";
  };

  config = {
    hardware.bluetooth.enable = lib.mkIf config.hardware.bluetooth.enable true;
  };
}
