{ pkgs, ... }:

{  
  home.packages = with pkgs; [
    # Convert nix hash to SRI format and fetch from URL
    (writeShellScriptBin "shash" ''
      nix hash to-sri --type sha256 $(nix-prefetch-url ''$1)
    '')

    # Create a Python virtual environment with --copies flag
    (writeShellScriptBin "create-venv" ''
      nix run nixpkgs#python3 -- -m venv .venv --copies
    '')
  ];
}
