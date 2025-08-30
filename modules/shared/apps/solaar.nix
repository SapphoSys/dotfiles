{ lib, config, ... }:
{
  options.settings.solaar.enable = lib.mkEnableOption "Enable Solaar" // {
    default = false;
  };

  config = lib.mkIf config.settings.solaar.enable {
    services.solaar = {
      enable = true;
      batteryIcons = "symbolic";
    };
  };
}