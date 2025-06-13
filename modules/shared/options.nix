{ lib, ... }:
{
  options.settings = {
    docker.enable = lib.mkEnableOption "Enable Docker" // {
      default = true;
    };

    flatpak.enable = lib.mkEnableOption "Enable Flatpak" // {
      default = true;
    };

    gui.enable = lib.mkEnableOption "Enable GUI packages";

    scripts.enable = lib.mkEnableOption "Enable scripts" // {
      default = true;
    };

    tailscale.enable = lib.mkEnableOption "Enable Tailscale" // {
      default = true;
    };

    vscode-remote.enable = lib.mkEnableOption "Enable the VSCode Remote server via nix-ld" // {
      default = false;
    };
  };
}
