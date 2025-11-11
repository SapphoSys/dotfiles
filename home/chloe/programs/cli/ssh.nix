{ lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks."*" = lib.mkMerge [
      # {
      #   # Default configuration for all hosts
      #   addKeysToAgent = "yes";
      #   identitiesOnly = true;
      # }
      (lib.mkIf pkgs.stdenv.isLinux {
        identityAgent = "~/.1password/agent.sock";
      })
      (lib.mkIf pkgs.stdenv.isDarwin {
        identityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      })
    ];
  };
}
