{
  lib,
  config,
  pkgs,
  user,
  inputs,
  flakePath,
  ...
}: let
  nixpkgs-review = pkgs.nixpkgs-review.override {withNom = true;};

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
in {
  imports = [inputs.nix-index-database.homeModules.nix-index];

  home = {
    packages = with pkgs;
      [
        nixd
        nix-output-monitor
        nix-tree
        nixpkgs-review
        nix-search-tv
        nvd
        nvfetcher
      ]
      ++ [ns];
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
        "Mod+N" = lib.custom.niri.openTerminal {
          app = "ns";
          terminal = config.profiles.${user}.defaultTerminal.package;
          app-id = lib.getName pkgs.nix-search-tv;
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
