{inputs, ...}: {
  flake.modules.nixos.nvidia = {
    config,
    pkgs,
    ...
  }: {
    services = {
      # set videodrivers to nvidia
      xserver.videoDrivers = ["nvidia"];
      # use vulkan backend on hazkey-server
      hazkey.server.package = inputs.nix-hazkey.packages.${pkgs.stdenv.hostPlatform.system}.hazkey-server.override {
        enableVulkan = true;
      };
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
  };
}
