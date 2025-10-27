{ pkgs, ... }:

{
  users.users.chloe = {
    name = "chloe";
    home = "/Users/chloe";
    shell = pkgs.zsh;
  };
}
