{ lib, config, ... }:

{
  options.settings.ssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable SSH service";
    };
    
    passwordAuthentication = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow password authentication";
    };
    
    permitRootLogin = lib.mkOption {
      type = lib.types.str;
      default = "no";
      description = "Permit root login via SSH";
    };
  };

  config = lib.mkIf config.settings.ssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = config.settings.ssh.passwordAuthentication;
        KbdInteractiveAuthentication = config.settings.ssh.passwordAuthentication;
        PermitRootLogin = config.settings.ssh.permitRootLogin;
      };
    };

    settings.firewall.allowedTCPPorts = [ 22 ];
  };
}
