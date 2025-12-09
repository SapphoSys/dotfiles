{
  # Enable Homebrew
  homebrew = {
    enable = true;

    # Update Homebrew and upgrade all packages on activation
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap"; # Uninstall all programs not declared
    };

    # Taps (third-party repositories)
    taps = [ ];

    # Formulae (CLI tools)
    brews = [
      "media-control"
      "mas"
    ];

    # Casks (GUI applications)
    casks = [
      "1password"
      "bruno"
      "crossover"
      "discord"
      "maccy"
      "microsoft-edge"
      "microsoft-teams"
      "mos"
      "music-presence"
      "prismlauncher"
      "osu"
      "signal"
      "steam"
    ];

    # Mac App Store apps (requires mas-cli)
    masApps = {
      "WhatsApp" = 310633997;
      "Telegram" = 747648890;
      "Tailscale" = 1475387142;
    };
  };
}
