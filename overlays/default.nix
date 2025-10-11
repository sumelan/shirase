{
  inputs,
  pkgs,
  ...
}: let
  # include generated sources from nvfetcher
  sources = import ../packages/nvfetcher/generated.nix {
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
      # include packages as pkgs.custom
      custom =
        (prev.custom or {})
        // {
          inherit
            (sources)
            # yazi
            yazi-plugins
            yazi-starship
            ;
        }
        // (import ../packages {
          inherit (prev) pkgs;
          inherit inputs;
        });
    })
  ];
}
