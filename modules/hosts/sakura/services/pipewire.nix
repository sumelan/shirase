_: {
  flake.modules.nixos."hosts/sakura" = {flakeLib, ...}: {
    services.pipewire = {
      wireplumber.extraConfig = let
        inherit (flakeLib.wireplumber {}) rename;
      in {
        # Rename ALSA devices
        "10-mic-rename" = rename {
          old = "alsa_input.pci-0000_34_00.6.analog-stereo";
          new = "Built-in Mic";
        };
        "10-fifine-sink-rename" = rename {
          old = "alsa_output.usb-FIFINE_683_Microphone_FIFINE_683_Microphone-00.analog-stereo";
          new = "FIFINE K683A Monitor";
        };
        "10-fifine-source-rename" = rename {
          old = "alsa_input.usb-FIFINE_683_Microphone_FIFINE_683_Microphone-00.analog-stereo";
          new = "FIFINE K683A Mic";
        };
      };
    };
  };
}
