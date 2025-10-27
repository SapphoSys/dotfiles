{ osConfig, ... }:
{
  programs.vscode = {
    inherit (osConfig.settings.profiles.graphical) enable;
  };
}
