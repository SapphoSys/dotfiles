{ lib, config, ... }:

{
  options.settings.bootloader.grub = {
    enable = lib.mkEnableOption "Enable GRUB bootloader (legacy/MBR)";
    device = lib.mkOption {
      type = lib.types.str;
      default = "/dev/sda";
      description = "Device to install GRUB to (for MBR/legacy boot)";
    };
  };

  config = lib.mkIf (config.settings.bootloader.enable && config.settings.bootloader.grub.enable) {
    boot.loader = {
      grub = {
        enable = true;
        device = config.settings.bootloader.grub.device;
      };
      systemd-boot.enable = lib.mkForce false;
    };
  };
}
