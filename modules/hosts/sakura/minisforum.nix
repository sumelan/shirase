{config, ...}: let
  inherit (config.flake.lib.wireplumber) rename;
in {
  flake.modules.nixos.minisforum = _: {
    # for makemkv to find usb bluray drive
    # https://discourse.nixos.org/t/makemkv-cant-find-my-usb-blu-ray-drive/23714
    boot.kernelModules = ["sg"];
    # rename audio devices
    services.pipewire.wireplumber.extraConfig = {
      "10-jbl-rename" = rename "alsa_output.usb-Harman_International_Industries_JBL_Pebbles_1.0.0-01.analog-stereo" "JBL Pebbles";
      "10-ifi-rename" = rename "alsa_output.usb-iFi_iFi_USB_Audio_SE_iFi_USB_Audio_SE-00.analog-stereo" "iFi Audio Uno";
      "10-fifine-sink-rename" = rename "alsa_output.usb-FIFINE_683_Microphone_FIFINE_683_Microphone-00.analog-stereo" "FIFINE K683A Monitor";
      "10-fifine-source-rename" = rename "alsa_input.usb-FIFINE_683_Microphone_FIFINE_683_Microphone-00.analog-stereo" "FIFINE K683A Mic";
      "10-mic-rename" = rename "alsa_input.pci-0000_34_00.6.analog-stereo" "Built-in Mic";
    };
  };
}
