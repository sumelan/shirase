{lib, ...}: {
  flake.modules.nixos.minisforum-um773se = {
    config,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-amd"];
    boot.extraModulePackages = [];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # https://github.com/NixOS/nixpkgs/issues/562919
    nixpkgs.overlays = [
      (final: prev: {
        linux-firmware = prev.linux-firmware.overrideAttrs (_: {
          version = "20260810";
          src = final.fetchFromGitLab {
            owner = "kernel-firmware";
            repo = "linux-firmware";
            tag = "20260810";
            hash = "sha256-P/fPpqaatp8Z2GV+I/OChiWGn6AhV+8w1RMFuX/LqHc=";
          };
        });
      })
    ];
  };
}
