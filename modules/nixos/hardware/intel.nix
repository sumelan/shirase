_: {
  flake.modules.nixos.intel = {config, ...}: {
    hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  };
}
