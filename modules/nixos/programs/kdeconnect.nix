{ lib, config, ... }:

{
  config = lib.mkIf config.settings.desktop.kde.enable {
    programs.kdeconnect.enable = true;
  };
}