{pkgs, ...}: let
  # include generated sources from nvfetcher
  sources = import ./generated.nix {
    inherit
      (pkgs)
      fetchFromGitHub
      fetchurl
      fetchgit
      dockerTools
      ;
  };
in {
  nixpkgs.overlays = [
    (_final: prev: {
      # include custom packages
      nvfetch =
        (prev.nvfetch or {})
        // {
          inherit (sources) yazi-plugins yazi-starship;
        };
    })
  ];
}
