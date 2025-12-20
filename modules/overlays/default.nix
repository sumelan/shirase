{
  inputs,
  pkgs,
  ...
}: let
  # include generated sources from nvfetcher
  dmsSources = import ./dms-plugins/generated.nix {
    inherit
      (pkgs)
      fetchFromGitHub
      fetchurl
      fetchgit
      dockerTools
      ;
  };
  yaziSources = import ./yazi-plugins/generated.nix {
    inherit
      (pkgs)
      fetchFromGitHub
      fetchurl
      fetchgit
      dockerTools
      ;
  };
  customOverlay = _final: prev: {
    custom =
      # include custom packages. usage: `pkgs.custom.foo`
      (prev.custom or {})
      // (import ../packages {
        inherit (prev) pkgs;
        inherit inputs;
      })
      # include custom source. usage: `pkgs.custom.bar.src`
      // {
        inherit (dmsSources) dms-plugins;
        inherit (yaziSources) yazi-plugins;
      };
  };
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
    customOverlay
    nautilusOverlay
    vlcOverlay
    # firefox-addons
    inputs.firefox-addons.overlays.default
  ];
}
