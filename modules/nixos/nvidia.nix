{config, ...}: {
  services = {
    # set videodrivers to nvidia
    xserver.videoDrivers = ["nvidia"];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = true;
      modesetting.enable = true; # required for Wayland
      # use official drivers
      open = false;
    };
  };
}
