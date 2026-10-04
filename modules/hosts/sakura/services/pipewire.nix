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
      };
    };
  };
}
