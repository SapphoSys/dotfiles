{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wsl-open
  ];
}
