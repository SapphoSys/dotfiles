{ lib, pkgs, osConfig, ... }:

let
  inherit (pkgs) ps util-linux socat;
  grep = pkgs.gnugrep;
in
{
  # WSL-specific SSH agent forwarding configuration
  # Forwards the Windows SSH agent to a Unix socket in WSL
  programs.zsh.initContent = lib.mkIf (osConfig ? wsl) ''
    export SSH_AUTH_SOCK=$HOME/.1password/agent.sock

    ALREADY_RUNNING=$(${ps}/bin/ps -auxww | ${grep}/bin/grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)

    if [[ $ALREADY_RUNNING != "0" ]]; then
        if [[ -S $SSH_AUTH_SOCK ]]; then
            # not expecting the socket to exist as the forwarding command isn't running (http://www.tldp.org/LDP/abs/html/fto.html)
            rm $SSH_AUTH_SOCK
        fi

        # otherwise, we start a new ssh-agent relay
        (${util-linux}/bin/setsid ${socat}/bin/socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
      fi
  '';
}
