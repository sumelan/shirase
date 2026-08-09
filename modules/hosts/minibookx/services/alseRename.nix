_: {
  flake.modules.nixos."hosts/minibookx" = {flakeLib, ...}: {
    services.pipewire.wireplumber.extraConfig = let
      inherit (flakeLib.wireplumber {}) rename;
    in {
      "10-speaker-rename" = rename {
        old = "alsa_output.pci-0000_00_1f.3.analog-stereo";
        new = "Built-in Speakers";
      };

      "10-nicehck-rename" = rename {
        old = "alsa_output.usb-TTGK_Technology_Co._Ltd_NICEHCK_NK1_MAX-00.analog-stereo";
        new = "NICEHCK NK1 MAX";
      };

      "10-input-rename" = rename {
        old = "alsa_input.pci-0000_00_1f.3.analog-stereo";
        new = "Built-in Mic";
      };
    };
  };
}
