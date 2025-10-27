{
  lib,
  pkgs,
  config,
  ...
}:

{
  config = lib.mkIf config.settings.hardware.laptop.enable {
    environment.systemPackages = with pkgs; [ asusctl ]; # Control panel for ASUS laptops

    services.asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
