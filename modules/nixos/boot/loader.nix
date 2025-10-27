{ lib, pkgs, config, ... }:

{
  options.settings.bootloader.enable = lib.mkEnableOption "Enable bootloader configuration";

  config = lib.mkIf config.settings.bootloader.enable {
    boot = {
      consoleLogLevel = 3;

      kernelPackages = pkgs.linuxPackages_latest;

      loader = {
        timeout = 2;
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
