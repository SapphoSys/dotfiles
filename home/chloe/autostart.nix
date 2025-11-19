{
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  config = lib.mkIf osConfig.settings.profiles.graphical.enable {
    xdg.configFile = {
      # .desktop files for autostart only work on Linux with XDG
      "autostart/1password.desktop" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        text = ''
          [Desktop Entry]
          Name=1Password
          Exec=1password --silent %U
          Terminal=false
          Type=Application
          Icon=1password
          StartupWMClass=1Password
          Comment=Password manager and secure wallet
          MimeType=x-scheme-handler/onepassword;
          Categories=Office;
        '';
      };
    };
  };
}
