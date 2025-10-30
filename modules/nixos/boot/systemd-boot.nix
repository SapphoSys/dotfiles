{ lib, config, ... }:

{
  options.settings.bootloader.systemd-boot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable systemd-boot bootloader (UEFI)";
    };
  };

  config =
    lib.mkIf (config.settings.bootloader.enable && config.settings.bootloader.systemd-boot.enable)
      {
        boot.loader = {
          timeout = 2;
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };
}
