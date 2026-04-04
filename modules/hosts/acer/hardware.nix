{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos.acer-al14 = {
    config,
    modulesPath,
    ...
  }: {
    imports =
      [flake.modules.nixos.laptop]
      ++ [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_usb_sdmmc"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];

    # 8 GB swap
    swapDevices = [
      {
        device = "/dev/disk/by-partuuid/5291374d-0510-4bd7-8cd3-552771640f47";
        randomEncryption.enable = true;
      }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
