{ lib, pkgs, osConfig, config, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    # zsh configuration file using XDG config directory
    dotDir = "${config.xdg.configHome}/zsh";

    initContent = ''
      # Add Homebrew to PATH on macOS
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      ''}
    '';

    envExtra = ''
      ${lib.optionalString pkgs.stdenv.isLinux ''
        export PRISMA_SCHEMA_ENGINE_BINARY="${pkgs.prisma-engines}/bin/schema-engine"
        export PRISMA_QUERY_ENGINE_BINARY="${pkgs.prisma-engines}/bin/query-engine"
        export PRISMA_QUERY_ENGINE_LIBRARY="${pkgs.prisma-engines}/lib/libquery_engine.node"
        export PRISMA_INTROSPECTION_ENGINE_BINARY="${pkgs.prisma-engines}/bin/introspection-engine"
        export PRISMA_FMT_BINARY="${pkgs.prisma-engines}/bin/prisma-fmt"
      ''}
    '';

    shellAliases = lib.mkMerge [
      {
        cat = "bat";
        cd = "z";
        ls = "eza";
      }

      (lib.mkIf (osConfig ? wsl) {
        ssh = "ssh.exe";
        ssh-add = "ssh-add.exe";
      })
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "1password"
        "bun"
        "colored-man-pages"
        "docker"
        "docker-compose"
        "git"
        "vscode"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k-config";
        src = ../../files;
        file = "p10k.zsh";
      }
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
    ];
  };
}
