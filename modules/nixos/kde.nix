{ lib, config, ... }:

{
  config = lib.mkIf config.settings.desktop.kde.enable {
    services.desktopManager.plasma6.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
