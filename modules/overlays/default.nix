_: {
  flake.modules.nixos.overlay = {pkgs, ...}: let
    # enable the A/V Properties and see details like media length
    nautilus = _final: prev: {
      nautilus = prev.nautilus.overrideAttrs (nprev: {
        buildInputs =
          nprev.buildInputs
          ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
          ]);
      });
    };
    # play Blu-ray disk
    vlc = _final: prev: {
      vlc = prev.vlc.override {
        libbluray-full = prev.libbluray.override {
          withAACS = true;
          withBDplus = true;
        };
      };
    };
    nordPatches = _final: prev: {
      nord = prev.yaziPlugins.nord.overrideAttrs (o: {
        patches = (o.patches or []) ++ [./nord.patch];
      });
    };
  in {
    nixpkgs.overlays = [
      nautilus
      vlc
      nordPatches
    ];
  };
}
