{
  description = "NixOS configuration for the Sapphic Angels system.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin theme
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Language Server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-ld
    nix-ld = {
      url = "github:nix-community/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS on WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fingerprint sensor for ThinkPad
    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor/24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Logitech config tool
    solaar = {
      url = "github:Svenum/Solaar-Flake/main"; # For latest stable version
      #url = "https://flakehub.com/f/Svenum/Solaar-Flake/0.1.1.tar.gz"; # uncomment line for solaar version 1.1.13
      #url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixos-hardware,
      nixos-wsl,
      nix-ld,
      solaar,
      ...
    }@inputs:
    let
      lib = import ./lib { inherit inputs; };

      forAllSystems =
        function:
        lib.genAttrs lib.systems.flakeExposed (system: function inputs.nixpkgs.legacyPackages.${system});
    in
    {
      inherit lib;

      # NixOS configurations
      nixosConfigurations = lib.mapAttrs lib.mkSystem {
        eris = { };
        sapphic = {
          modules = [
            solaar.nixosModules.default
          ];
        };

        lavender = {
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
        };

        solstice = {
          modules = [
            nix-ld.nixosModules.nix-ld
            nixos-wsl.nixosModules.default
          ];
        };
      };

      # packages = forAllSystems (pkgs: {
      #   cider = pkgs.callPackage ./packages/cider.nix { };
      # });

      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
