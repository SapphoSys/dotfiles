{ pkgs, ... }:

{
  users.users = {
    chloe = {
      isNormalUser = true;

      extraGroups = [
        "networkmanager"
        "wheel"
      ];

      shell = pkgs.zsh;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJOAijXc0QNfeoCsQkaB7ybm9G+4EpFthOGy+fy+YbT"
      ];
    };
  };
}
