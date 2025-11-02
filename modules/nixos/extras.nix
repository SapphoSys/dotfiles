{ inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.ragenix.nixosModules.default
  ];

  age.identityPaths = [
    "/home/chloe/.ssh/id_ed25519.age"
    "/home/chloe/.ssh/id_ed25519.auth"
    "/home/chloe/.ssh/id_ed25519.sign"
  ];
}
