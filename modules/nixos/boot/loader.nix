{ lib, ... }:

{
  options.settings.bootloader.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable the system bootloader.";
  };
}
