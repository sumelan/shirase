{
  pkgs,
  inputs,
  flakePath,
  ...
}:
let
  nixpkgs-review = pkgs.nixpkgs-review.override { withNom = true; };

  ns = pkgs.writeShellApplication {
    name = "ns";
    runtimeInputs = with pkgs; [
      fzf
      nix-search-tv
    ];
    # ignore checks since i didn't write this
    checkPhase = "";
    text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
  };
in
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  home = {
    packages =
      with pkgs;
      [
        nixd
        nix-output-monitor
        nix-tree
        nixfmt-rfc-style
        nixpkgs-review
        nix-search-tv
        nvd
        nvfetcher
      ]
      ++ [ ns ];
  };

  programs = {
    nix-index.enable = true;
    nh = {
      enable = true;
      clean.extraArgs = "--keep 5";
      flake = flakePath;
    };
  };

  custom.persist = {
    home = {
      cache.directories = [
        ".cache/nix-index"
        ".cache/nix-search-tv"
      ];
    };
  };
}
