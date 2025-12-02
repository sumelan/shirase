{
  lib,
  pkgs,
  flakePath,
  ...
}: let
  inherit (lib.custom.colors) blue0;
  inherit (lib.custom.niri) spawn hotkey;
in {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      nix-output-monitor
      nix-tree
      nix-search-tv
      nixd
      nvd
      nvfetcher
      ;
    nixpkgs-reviewPackage = pkgs.nixpkgs-review.override {withNom = true;};
    nsPackage = pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = [
        pkgs.fzf
        pkgs.nix-search-tv
      ];
      # ignore checks since i didn't write this
      checkPhase = "";
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    };
  };

  programs = {
    nix-index.enable = true;
    nh = {
      enable = true;
      clean.extraArgs = "--keep 5";
      flake = flakePath;
    };

    niri.settings = {
      binds = {
        "Mod+Alt+N" = {
          action.spawn = spawn "foot --app-id=nix-search-tv ns";
          hotkey-overlay.title = hotkey {
            color = blue0;
            name = "󱄅  nix-search-tv";
            text = "Nix Fuzzey Search";
          };
        };
      };
    };
  };

  custom.persist = {
    home.cache.directories = [
      ".cache/nix-index"
      ".cache/nix-search-tv"
    ];
  };
}
