{
  # Custom settings not supported directly by nix-darwin.
  # TODO: Research other useful custom settings.
  # https://github.com/yannbertrand/macos-defaults

  system.defaults.CustomUserPreferences = {
    # Lock the size of the dock.
    "com.apple.dock".size-immutable = true;

    # Prevent creation of .DS_Store files on network or USB volumes.
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
  };
}
