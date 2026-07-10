{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos.chuwi-minibook-x = {
    config,
    pkgs,
    modulesPath,
    ...
  }: {
    imports =
      [
        (modulesPath + "/installer/scan/not-detected.nix")
      ]
      ++ (with flake.modules.nixos; [laptop intel]);

    boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci"];
    boot.initrd.kernelModules = ["i915"];
    boot.initrd.extraFirmwarePaths = ["vbt"];
    boot.kernelModules = ["kvm-intel"];
    boot.kernelParams = [
      "quiet"
      "i915.vbt_firmware=vbt"
      # Fixes the display being rotated 90 degrees.
      "fbcon=rotate:1"
      "video=DSI-1:panel_orientation=right_side_up"
    ];
    boot.extraModulePackages = [];

    # 8 GB swap
    swapDevices = [
      {
        device = "/dev/disk/by-partuuid/bd6f05f3-1b5b-450a-b8d6-b9aa5c8b8135";
        randomEncryption.enable = true;
      }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    hardware.firmware = let
      vbtFirmware = pkgs.runCommand "firmware-vbt-patched" {} ''
        mkdir -p $out/lib/firmware
        cp "${./vbt_patched.bin}" $out/lib/firmware/vbt
      '';
    in [vbtFirmware];

    services.iio-niri = {
      enable = true;
      extraArgs = ["--monitor" "DSI-1" "--transform" "90" "180" "270" "normal"];
    };

    # rotate limine interface
    boot.loader.limine.extraConfig = ''
      interface_rotation: 90
    '';
  };
}
