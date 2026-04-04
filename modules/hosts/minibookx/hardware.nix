{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos.chuwi-minibook-x = {
    config,
    modulesPath,
    ...
  }: let
    inherit (flake.lib.wireplumber) rename;
  in {
    imports =
      [flake.modules.nixos.laptop]
      ++ [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

    boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
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

    services.iio-niri = {
      enable = true;
      extraArgs = ["--monitor" "DSI-1" "--transform" "90" "180" "270" "normal"];
    };

    # rotate limine interface
    boot.loader.limine.extraConfig = ''
      interface_rotation: 90
    '';

    # rename audio devices
    services.pipewire.wireplumber.extraConfig = {
      "10-speaker-rename" = rename "alsa_output.pci-0000_00_1f.3.analog-stereo" "Built-in Speakers";
      "10-dac-rename" = rename "alsa_output.usb-TTGK_Technology_Co._Ltd_NICEHCK_NK1_MAX-00.analog-stereo" "NICEHCK NK1 MAX";
      "10-input-rename" = rename "alsa_input.pci-0000_00_1f.3.analog-stereo" "Built-in Mic";
    };
  };
}
