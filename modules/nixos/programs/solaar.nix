{ lib, config, inputs, ... }:

{
  imports = [
    inputs.solaar.nixosModules.solaar
  ];

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