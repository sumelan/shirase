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
  }: let
    inherit (flake.lib.wireplumber) rename;
  in {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

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

    services.pipewire.wireplumber.extraConfig = {
      "10-creative-rename" = rename "alsa_output.usb-Creative_Technology_Ltd_Creative_Stage_SE_mini_1120041300020421-01.analog-stereo" "Creative Stage SE mini";
      "10-ifi-rename" = rename "alsa_output.usb-iFi_iFi_USB_Audio_SE_iFi_USB_Audio_SE-00.analog-stereo" "iFi Audio Uno";
      "10-shanling-rename" = rename "alsa_output.usb-Shanling_Shanling_H0-00.analog-stereo" "Shanling H0";
      "10-fifine-sink-rename" = rename "alsa_output.usb-FIFINE_683_Microphone_FIFINE_683_Microphone-00.analog-stereo" "FIFINE K683A Monitor";
      "10-fifine-source-rename" = rename "alsa_input.usb-FIFINE_683_Microphone_FIFINE_683_Microphone-00.analog-stereo" "FIFINE K683A Mic";
      "10-mic-rename" = rename "alsa_input.pci-0000_34_00.6.analog-stereo" "Built-in Mic";
    };
  };
}
