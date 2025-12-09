{ inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.ragenix.nixosModules.default
    inputs.srcds-nix.nixosModules.default
    inputs.tangled.nixosModules.knot
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];
}
