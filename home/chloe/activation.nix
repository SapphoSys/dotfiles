# macOS Tahoe (26.x) no longer supports symlinks in the Launchpad.
# So, we're forced to copy applications instead of linking them.
# This is computationally slower, but we're left with no choice.

{
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    targets.darwin.copyApps = {
      enable = true;
      enableChecks = true;
    };

    targets.darwin.linkApps.enable = false;
  };
}
