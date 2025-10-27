{ lib, config, ... }:

{
  options.settings.hardware.audio.enable = lib.mkEnableOption "Enable audio support";

  config = lib.mkIf config.settings.hardware.audio.enable {
    security.rtkit.enable = true; # (Optional) Enable rtkit for low-latency audio

    services.pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      pulse.enable = true;
    };

    users.users.chloe.extraGroups = lib.mkForce (lib.unique (config.users.users.chloe.extraGroups ++ [ "audio" ]));
  };
}
