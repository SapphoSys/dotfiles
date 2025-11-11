{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.ghostty else pkgs.ghostty-bin;

    settings = {
      command = "${pkgs.zsh}/bin/zsh";
      auto-update = "off";

      font-family = "Iosevka";
      font-size = 14;

      adjust-cell-height = "10%";
      adjust-cell-width = "0";

      background = "1e1e2e";
      foreground = "cdd6f4";

      palette = [
        "0=#45475a"
        "1=#f38ba8"
        "2=#a6e3a1"
        "3=#f9e2af"
        "4=#89b4fa"
        "5=#f5c2e7"
        "6=#94e2d5"
        "7=#bac2de"
        "8=#585b70"
        "9=#f38ba8"
        "10=#a6e3a1"
        "11=#f9e2af"
        "12=#89b4fa"
        "13=#f5c2e7"
        "14=#94e2d5"
        "15=#a6adc8"
      ];

      cursor-style = "bar";
      cursor-color = "f5c2e7";
      cursor-style-blink = true;
      cursor-opacity = 1;

      selection-foreground = "1e1e2e";
      selection-background = "cdd6f4";

      window-padding-x = 8;
      window-padding-y = 8;
      window-padding-balance = true;
      window-decoration = "client";
      window-theme = "dark";

      window-width = 120;
      window-height = 25;

      window-save-state = "always";
      window-vsync = true;

      scrollback-limit = 268435456;

      copy-on-select = "clipboard";

      confirm-close-surface = true;

      shell-integration = "detect";
      shell-integration-features = [
        "cursor"
        "sudo"
        "title"
        "ssh-env"
        "ssh-terminfo"
      ];

      keybind = [
        "super+n=new_window"
        "super+t=new_tab"
        "super+shift+w=close_surface"
        "super+w=close_window"
        "super+shift+n=new_split:right"
        "super+shift+d=new_split:down"
        "super+shift+j=goto_split:previous"
        "super+shift+k=goto_split:next"
        "super+shift+h=goto_split:left"
        "super+shift+l=goto_split:right"
        "super+shift+up=goto_split:up"
        "super+shift+down=goto_split:down"
        "super+equal=increase_font_size:1"
        "super+minus=decrease_font_size:1"
        "super+0=reset_font_size"
        "cmd+shift+comma=reload_config"
        "super+f=toggle_fullscreen"
        "super+shift+f=toggle_quick_terminal"
      ];

      macos-option-as-alt = true;
      macos-titlebar-style = "tabs";
      macos-window-shadow = true;
      macos-non-native-fullscreen = false;

      background-blur = 40;
      background-opacity = 0.85;
    };
  };
}
