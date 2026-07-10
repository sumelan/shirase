{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos.minisforum-um773se = {
    config,
    modulesPath,
    ...
  }: {
    imports =
      [
        (modulesPath + "/installer/scan/not-detected.nix")
      ]
      ++ (with flake.modules.nixos; [amd]);

    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-amd"];
    boot.extraModulePackages = [];

    # 8 GB swap
    swapDevices = [
      {
        device = "/dev/disk/by-partuuid/c4289319-6e7f-4534-b651-8b6cbdd1fcc3";
        randomEncryption.enable = true;
      }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
