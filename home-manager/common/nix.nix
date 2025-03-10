{
  pkgs,
  dotfiles,
  ...
}:
let
  nixpkgs-review = pkgs.nixpkgs-review.override { withNom = true; };
in
{
  home = {
    packages = with pkgs; [
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

  programs = {
    nix-index.enable = true;
    nh = {
      enable = true;
      flake = dotfiles;
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep 5 --keep-since 3d";
      };
    };
  };

  custom.persist = {
    home = {
      cache.directories = [ ".cache/nix-index" ];
    };
  };
}
