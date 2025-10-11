{
  inputs,
  pkgs,
  ...
}: let
  # include generated sources from nvfetcher
  yaziSources = import ../packages/yazi-plugins/generated.nix {
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
      custom =
        (prev.custom or {})
        # include packages defined as pkgs.custom.bar
        // (import ../packages {
          inherit (prev) pkgs;
          inherit inputs;
        })
        # include yazi-plugins defined and updated through nvfetcher
        # as pkgs.custom.
        // {
          inherit (yaziSources) yazi-plugins yazi-starship;
        };
    })
  ];
}
