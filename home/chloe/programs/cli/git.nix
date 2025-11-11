{
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICM6XP+CNc2CStEDe/W4LfkcRcG98obQiM2aqnydCRbX";

  opSshSignPath =
    if (osConfig ? wsl) then
      "/mnt/c/Users/Chloe/AppData/Local/1Password/app/8/op-ssh-sign-wsl"
    else if pkgs.stdenv.hostPlatform.isDarwin then
      "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else
      "${pkgs._1password-gui}/bin/op-ssh-sign";
in
{
  home.file.".ssh/allowed_signers".text = "* ${signingKey}";

  programs.git = {
    enable = true;

    settings = lib.mkMerge [
      {
        user = {
          name = "Chloe A";
          email = "chloe@sapphic.moe";
          signingkey = signingKey;
        };

        gpg = {
          format = "ssh";
          ssh.program = opSshSignPath;
          ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        };

        commit.gpgsign = true;
      }

      (lib.mkIf (osConfig ? wsl) {
        core.sshCommand = "ssh.exe";
      })
    ];
  };
}
