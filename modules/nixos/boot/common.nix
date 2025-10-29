{ lib, pkgs, config, ... }:

{
  config = lib.mkIf config.settings.bootloader.enable {
    boot = {
      consoleLogLevel = 3;
      kernelPackages = pkgs.linuxPackages_latest;
    };
  };
}
