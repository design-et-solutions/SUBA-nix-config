{ pkgs, config, ... }: {
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.systemPackages = with pkgs;
    [
      linuxPackages.nvidia_x11 # NVIDIA X11 driver for Linux
    ];
}
