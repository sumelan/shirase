_: {
  flake.modules.nixos."hosts/minibookx" = {flakeLib, ...}: {
    services.pipewire.wireplumber.extraConfig = let
      inherit (flakeLib.wireplumber {}) rename;
    in {
      "10-speaker-rename" = rename {
        old = "alsa_output.pci-0000_00_1f.3.analog-stereo";
        new = "Built-in Speakers";
      };
      "10-input-rename" = rename {
        old = "alsa_input.pci-0000_00_1f.3.analog-stereo";
        new = "Built-in Mic";
      };
    };
  };
}
