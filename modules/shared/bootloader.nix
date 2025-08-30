{ lib, pkgs, config, ... }:
{
  options.settings.bootloader.enable = lib.mkEnableOption "Enable bootloader configuration";

  config = lib.mkIf config.settings.bootloader.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
