_: {
  flake.modules.nixos.intel = {
    config,
    pkgs,
    ...
  }: {
    hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    boot.initrd.kernelModules = ["i915"]; # or "xe"

    hardware.graphics.extraPackages = [
      pkgs.intel-vaapi-driver
      pkgs.intel-media-driver
    ];
  };
}
