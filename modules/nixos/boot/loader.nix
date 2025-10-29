{ lib, ... }:

{
  options.settings.bootloader.enable = lib.mkEnableOption "Enable bootloader configuration";
}
