{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    wget
    unzip
    nil
    jq
    nixfmt
    just
    ragenix
  ];
}
