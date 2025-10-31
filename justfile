[private]
_default:
  @just --list

[private]
[macos]
boot:
  echo "❌ Unsupported operation on macOS"
  exit 1

[linux]
boot:
  nh os boot .

[macos]
build:
  nh darwin build .

[linux]
build:
  nh os build .

[macos]
switch:
  nh darwin switch .

[linux]
switch:
  nh os switch .

check:
  nix flake check

clean:
  nix-collect-garbage --delete-older-than 3d
  nix store optimise

update:
  nix flake update