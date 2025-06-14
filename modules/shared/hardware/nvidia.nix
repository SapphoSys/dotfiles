{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.settings.hardware.nvidia.enable = lib.mkEnableOption "Nvidia driver support";

  config = lib.mkIf config.settings.hardware.nvidia.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Load NVIDIA driver for X11 and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = false;

      package = config.boot.kernelPackages.nvidiaPackages.production;
      powerManagement = {
        enable = false;
        finegrained = true;
      };

      # Ensure the kernel doesn't tear down the card/driver prior to X startup due to the card powering down.
      nvidiaPersistenced = true;

      # the following is required for amdgpu/nvidia pairings.
      modesetting.enable = true;
      prime = {
        offload.enable = true;

        # Bus ID of AMD and NVIDIA GPUs.
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
