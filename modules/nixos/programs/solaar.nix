{ lib, config, inputs, ... }:

{
  imports = [
    inputs.solaar.nixosModules.solaar
  ];

  options.settings.software.solaar.enable = lib.mkEnableOption "Enable Solaar";

  config = lib.mkIf config.settings.software.solaar.enable {
    services.solaar = {
      enable = true;
      batteryIcons = "symbolic";
    };
  };
}