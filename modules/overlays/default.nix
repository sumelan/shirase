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
    nordIcon = _final: prev: {
      nord = prev.yaziPlugins.nord.overrideAttrs {
        src = prev.fetchFromGitHub {
          owner = "sumelan";
          repo = "nord.yazi";
          rev = "0b97c8464ae073450e8ef10f80c89f8d07c65902";
          hash = "sha256-W8lcF40GhbdcM1PXL0SodfrOMSnpUV+Lowgzt1lRju4=";
        };
      };
    };
  in {
    nixpkgs.overlays = [
      nautilus
      vlc
      nordIcon
    ];
  };
}
