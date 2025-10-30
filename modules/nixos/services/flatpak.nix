{ config, ... }:

{
  config = {
    services.flatpak.enable = config.settings.profiles.graphical.enable;
  };
}
