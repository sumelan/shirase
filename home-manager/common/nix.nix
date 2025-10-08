{
  lib,
  config,
  pkgs,
  flakePath,
  ...
}: let
  inherit
    (lib)
    getExe
    ;
in {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      nixd
      nix-output-monitor
      nix-tree
      nix-search-tv
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
        "Mod+Period" = {
          action.spawn = ["${getExe pkgs.foot}" "--app-id=nix-search-tv" "ns"];
          hotkey-overlay.title = ''<span foreground="${config.lib.stylix.colors.withHashtag.base0B}">[Terminal]</span> nix-search-tv'';
        };
      };
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
