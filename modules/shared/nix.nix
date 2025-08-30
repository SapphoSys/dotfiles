{
  nix = {
    # Set up Nix's garbage collector to run automatically.
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
    
    settings = {
      # Literally a CVE waiting to happen.
      accept-flake-config = false;

      # Optimize symlinks.
      auto-optimise-store = true;

      # Enable Nix commands and flakes.
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Max number of parallel TCP connections for fetching imports and binary caches.
      http-connections = 50;

      # Show more log lines for failed builds.
      log-lines = 30;

      # Let the system decide the number of max jobs.
      max-jobs = "auto";

      # Free up to 20GiB whenever there's less than 5GiB left.
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 20 * 1024 * 1024 * 1024;

      # We don't want to track the registry,
      # but we do want to allow the usage of `flake:` references.
      use-registries = true;
      flake-registry = "";

      # Use XDG Base Directories for all Nix things.
      use-xdg-base-directories = true;

      # Don't warn about dirty working directories.
      warn-dirty = false;
    };
  };

  # Allow unfree packages. 
  # This is sadly not enough as I still have to pass the --impure flag.
  nixpkgs.config.allowUnfree = true;
}
