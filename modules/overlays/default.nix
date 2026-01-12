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
    # play Blu-ray disk
    vlcOverlay = _final: prev: {
      vlc = prev.vlc.override {
        libbluray-full = prev.libbluray.override {
          withAACS = true;
          withBDplus = true;
        };
      };
    };
    yatline = _final: prev: {
      yatline = prev.yaziPlugins.yatline.overrideAttrs {
        patches = [
          (prev.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/imsi32/yatline.yazi/pull/71.diff";
            hash = "sha256-YUFlDzSx8X4XIeYVOX+PRVZxND7588nl0vr3V+h6hus=";
          })
          (prev.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/imsi32/yatline.yazi/pull/67.diff";
            hash = "sha256-omNbc2dSldLZyuoSwx8hjvDR11cb0tozpqp/ooY0sMs=";
          })
        ];
      };
    };
    nordic-yazi = _final: prev: {
      nord = prev.yaziPlugins.nord.overrideAttrs {
        src = prev.fetchFromGitHub {
          owner = "sumelan";
          repo = "nord.yazi";
          rev = "c45fde5a57951a7b8f2e1c783fa1392a76a70622";
          hash = "sha256-MxHux3yKsegqWdVJjTno4547tfMUKRNIWYQ3IK6ucpo=";
        };
      };
    };
  in {
    nixpkgs.overlays = [
      nautilusOverlay
      vlcOverlay
      yatline
      nordic-yazi
      # niri-flake
      inputs.niri-flake.overlays.niri
      # firefox-addons
      inputs.firefox-addons.overlays.default
    ];
  };
}
