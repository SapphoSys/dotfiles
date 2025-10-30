{
  config,
  lib,
  ...
}:

{
  options = {
    settings.virtualization.docker.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Docker virtualization support.";
    };

    settings.virtualization.waydroid.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Waydroid Android container support.";
    };
  };

  config = {
    virtualisation.docker.enable = config.settings.virtualization.docker.enable;
    virtualisation.waydroid.enable = config.settings.virtualization.waydroid.enable;

    users.users.chloe.extraGroups = lib.mkIf config.settings.virtualization.docker.enable [ "docker" ];
  };
}
