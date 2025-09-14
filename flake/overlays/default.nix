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
      custom =
        (prev.custom or {})
        // {
          inherit (sources) yazi-plugins yazi-starship;
        };
    })
  ];
}
