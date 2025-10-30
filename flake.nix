{
  description = "NixOS configuration for the Sapphic Angels system.";

  inputs = {
    # Packages
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Flakes
    flake-parts.url = "github:hercules-ci/flake-parts";
    easy-hosts.url = "github:tgirlcloud/easy-hosts";

    # Systems
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Userspace
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Misc
    ## Catppuccin theme
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Nix Language Server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Logitech config tool
    solaar = {
      url = "github:Svenum/Solaar-Flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      nixos-wsl,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.easy-hosts.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt;
        };

      easy-hosts = {
        path = ./hosts;

        additionalClasses = {
          wsl = "nixos";
        };

        shared = {
          modules = [
            # Base modules (platform-agnostic)
            ./modules/base
          ];
          specialArgs = {
            inherit inputs;
          };
        };

        perClass = class: {
          modules = [
            ./modules/${class}/default.nix
          ];
        };

        hosts = {
          caulfield = {
            arch = "x86_64";
            class = "nixos";
            tags = [ "laptop" ];
          };

          dullscythe = {
            arch = "x86_64";
            class = "nixos";
            tags = [ "server" ];
          };

          juniper = {
            arch = "aarch64";
            class = "darwin";
            tags = [ "laptop" ];
          };

          solstice = {
            arch = "x86_64";
            class = "wsl";
            tags = [ "wsl" ];
          };
        };
      };
    };
}
