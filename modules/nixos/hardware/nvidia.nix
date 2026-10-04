_: {
  flake.modules.nixos.nvidia = {config, ...}: {
    # set videodrivers to nvidia
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true; # required for Wayland
      # use official drivers
      open = false;
    };
  };
}
