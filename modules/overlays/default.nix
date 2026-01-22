{inputs, ...}: {
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
    yatlinePatches = _final: prev: {
      yatline = prev.yaziPlugins.yatline.overrideAttrs (o: {
        patches =
          (o.patches or [])
          ++ [
            (prev.fetchpatch {
              url = "https://patch-diff.githubusercontent.com/raw/imsi32/yatline.yazi/pull/71.diff";
              hash = "sha256-YUFlDzSx8X4XIeYVOX+PRVZxND7588nl0vr3V+h6hus=";
            })
            (prev.fetchpatch {
              url = "https://patch-diff.githubusercontent.com/raw/imsi32/yatline.yazi/pull/67.diff";
              hash = "sha256-omNbc2dSldLZyuoSwx8hjvDR11cb0tozpqp/ooY0sMs=";
            })
          ];
      });
    };
    nordPatches = _final: prev: {
      nord = prev.yaziPlugins.nord.overrideAttrs (o: {
        patches = (o.patches or []) ++ [./nord.patch];
      });
    };
    time-travelPatches = _final: prev: {
      time-travel = prev.yaziPlugins.time-travel.overrideAttrs (o: {
        patches = (o.patches or []) ++ [./time-travel.patch];
      });
    };
  in {
    nixpkgs.overlays = [
      nautilus
      vlc
      yatlinePatches
      nordPatches
      time-travelPatches
    ];
  };
}
