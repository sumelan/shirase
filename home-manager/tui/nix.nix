{
  pkgs,
  host,
  inputs,
  dotfiles,
  ...
}:
let
  nixpkgs-review = pkgs.nixpkgs-review.override { withNom = true; };
in
{
  home = {
    packages = with pkgs; [
      nh
      nixd
      nix-output-monitor
      nix-tree
      nixfmt-rfc-style
      nixpkgs-review
      nvfetcher
    ];

    shellAliases = {
      nfl = "nix flake lock";
      nfu = "nix flake update";
      nsh = "nix-shell --command fish -p";
      nshp = "nix-shell --pure --command fish -p";
    };
  };

  programs.nix-index.enable = true;

  custom.persist = {
    home = {
      cache.directories = [ ".cache/nix-index" ];
    };
  };
}
