{
  imports = [
    ../shared

    ./nix.nix
    ./packages.nix
    ./zsh.nix
  ];

  age.identityPaths = [
    "/home/chloe/.ssh/id_ed25519.age"
    "/home/chloe/.ssh/id_ed25519.auth"
    "/home/chloe/.ssh/id_ed25519.sign"
  ];
}
