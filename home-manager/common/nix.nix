{
  lib,
  config,
  pkgs,
  user,
  inputs,
  ...
}:
let
  nixpkgs-review = pkgs.nixpkgs-review.override { withNom = true; };
  ns =
    builtins.fetchurl {
      url = "https://raw.githubusercontent.com/3timeslazy/nix-search-tv/refs/heads/main/nixpkgs.sh";
      sha256 = "sha256-/usZX16ept4bXAf10jggeVwOn8B7Rs2dV48F9Jc0dbk=";
    }
    |> builtins.readFile
    |> pkgs.writeShellScriptBin "ns";
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
      flake = config.profiles.${user}.flakePath;
    };
    niri.settings.binds = {
      "Mod+N" = lib.custom.niri.openTerminal {
        app = "ns";
        terminal = config.profiles.${user}.defaultTerminal.package;
        app-id = lib.getName pkgs.nix-search-tv;
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
