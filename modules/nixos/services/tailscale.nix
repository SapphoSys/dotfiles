{ lib, config, ... }:

{
  options = {
    settings.tailscale.enable = lib.mkEnableOption "Enable Tailscale" // {
      default = false;
    };
  };
  
  config = {
    services.tailscale = {
      enable = config.settings.tailscale.enable;
      useRoutingFeatures = "both";
    };
  };
}