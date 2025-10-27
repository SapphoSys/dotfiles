{ lib, osConfig, pkgs, ... }:

{
  xdg.configFile = {
    # 1Password configuration
    # https://developer.1password.com/docs/ssh/agent/config
    "1Password/ssh/agent.toml".text = ''
      [[ssh-keys]]
      vault = "SSH"
    '';
  };

  home.file = {
    # Catppuccin theme for Konsole (KDE terminal)
    # Only on systems with KDE enabled
    ".local/share/konsole/catppuccin-mocha.colorscheme" = lib.mkIf (osConfig.settings.desktop.kde.enable or false) {
      source =
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "konsole";
          rev = "7d86b8a1e56e58f6b5649cdaac543a573ac194ca";
          sha256 = "sha256-EwSJMTxnaj2UlNJm1t6znnatfzgm1awIQQUF3VPfCTM=";
        }
        + "/Catppuccin-Mocha.colorscheme";
    };
  };
}
