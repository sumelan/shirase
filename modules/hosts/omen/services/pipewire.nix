_: {
  flake.modules.nixos."hosts/omen" = {flakeLib, ...}: {
    services.pipewire = {
      wireplumber.extraConfig = let
        inherit (flakeLib.wireplumber {}) rename;
      in {
        # Rename ALSA devices
        "10-creative-rename" = rename {
          old = "alsa_output.usb-Creative_Technology_Ltd_Creative_Stage_SE_mini_1120041300020421-01.analog-stereo";
          new = "Creative Stage SE mini";
        };
      };
    };
  };
}
