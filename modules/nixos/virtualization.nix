{
  config,
  lib,
  ...
}:

{
  options = {
    settings.docker.enable = lib.mkEnableOption "Enable Docker" // {
      default = true;
    };
  };
  
  config = {
    virtualisation.docker.enable = config.settings.docker.enable;

    users.users.chloe.extraGroups = lib.mkForce (lib.unique (config.users.users.chloe.extraGroups ++ [ "docker" ]));
  };
}