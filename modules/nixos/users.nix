{ pkgs, ... }:

{
  users.users = {
    chloe = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
      shell = pkgs.zsh;
    };
  };
}
