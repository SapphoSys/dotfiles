{
  config,
  lib,
  ...
}:

{
  options = {
    settings.docker.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Docker virtualization support.";
    };
  };
  
  config = {
    virtualisation.docker.enable = config.settings.docker.enable;

    users.users.chloe.extraGroups = [ "docker" ];
  };
}