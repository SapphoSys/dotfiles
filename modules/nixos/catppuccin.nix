{ inputs, ... }:

{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  catppuccin = {
    enable = true;
    accent = "pink";
    flavor = "mocha";
  };
}
