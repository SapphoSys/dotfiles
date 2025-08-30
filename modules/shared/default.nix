{
  config,
  ...
}:

{
  imports = [
    ./apps
    ./hardware
    ./bootloader.nix
    ./catppuccin.nix
    ./kde.nix
    ./nix.nix
    ./options.nix
    ./packages.nix
    ./users.nix
    ./zsh.nix
  ];
  
  config = {
    programs = {
      dconf.enable = true; # Fix missing cursors on Firefox
      nix-ld.enable = config.settings.vscode-remote.enable; # Enable the VSCode Remote server via nix-ld
    };

    services = {
      flatpak.enable = config.settings.flatpak.enable;
      tailscale = {
        enable = config.settings.tailscale.enable;
        useRoutingFeatures = "both";
      };
    };

    time = {
      timeZone = "Asia/Almaty";
      hardwareClockInLocalTime = true; # Keep time synced on Windows and NixOS
    };

    virtualisation.docker.enable = config.settings.docker.enable;

    security.polkit.enable = true; # Enable PolKit for system authentication in 1Password
  };
}
