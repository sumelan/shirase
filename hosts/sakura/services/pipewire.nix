{customLib, ...}: {
  services.pipewire = {
    wireplumber.extraConfig = let
      inherit (customLib.wireplumber {}) rename;
    in {
      # Rename ALSA devices
      "10-mic-rename" = rename {
        old = "alsa_input.pci-0000_34_00.6.analog-stereo";
        new = "Built-in Mic";
      };
    };
  };
}
