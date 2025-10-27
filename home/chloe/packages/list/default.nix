{ pkgs }:

with pkgs; [
  # dev tools
  nodejs
  deno
  cloudflared
  corepack_latest
  bun

  # fonts
  iosevka
  inter
  atkinson-hyperlegible
  nerd-fonts.jetbrains-mono

  # other
  _1password-cli
]