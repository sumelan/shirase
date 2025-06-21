{
  config,
  pkgs,
  inputs,
  ...
}:
let
  nixpkgs-review = pkgs.nixpkgs-review.override { withNom = true; };
in
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  home = {
    packages = with pkgs; [
      nixd
      nix-output-monitor
      nix-tree
      nixfmt-rfc-style
      nixpkgs-review
      nurl
    ];
  };

  programs = {
    nix-index.enable = true;
    nh = {
      enable = true;
      flake = "/persist${config.home.homeDirectory}/projects/shirase";
    };
  };

  custom.persist = {
    home = {
      cache.directories = [ ".cache/nix-index" ];
    };
  };
}
