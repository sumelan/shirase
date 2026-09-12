_: {
  flake.modules.nixos.nvidia = _: {
    # set videodrivers to nvidia
    services.xserver.videoDrivers = ["nvidia"];
    # use official drivers
    hardware.nvidia.open = false;
  };
}
