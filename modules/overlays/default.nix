{inputs, ...}: {
  flake.modules.nixos.overlay = {pkgs, ...}: let
    # enable the A/V Properties and see details like media length
    nautilusOverlay = _final: prev: {
      nautilus = prev.nautilus.overrideAttrs (nprev: {
        buildInputs =
          nprev.buildInputs
          ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
          ]);
      });
    };
    # play Bluray disk
    vlcOverlay = _final: prev: {
      vlc = prev.vlc.override {
        libbluray = prev.libbluray.override {
          withAACS = true;
          withBDplus = true;
        };
      };
    };
  in {
    nixpkgs.overlays = [
      nautilusOverlay
      vlcOverlay
      # niri-flake
      inputs.niri-flake.overlays.niri
      # firefox-addons
      inputs.firefox-addons.overlays.default
    ];
  };
}
