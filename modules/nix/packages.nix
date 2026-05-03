{
  config,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages = {
      # tui for searching nix packages or options
      ntv = pkgs.writeShellApplication {
        name = "ntv";
        runtimeInputs = [
          pkgs.fzf
          pkgs.nix-search-tv
        ];
        # prevent IFD, thanks @Michael-C-Buckley
        text =
          # sh
          ''exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"'';
      };
    };
  };

  flake.modules.nixos = {
    default = {pkgs, ...}: {
      nixpkgs.overlays = [
        (_: prev: {
          nixpkgs-review = prev.nixpkgs-review.override {withNom = true;};
        })
      ];

      environment.systemPackages = [
        pkgs.nix-init
        pkgs.nixpkgs-review # overlay-ed above
      ];

      custom.fileSystem = {
        cache.home.directories = [
          ".cache/nix-search-tv"
          ".cache/nixpkgs-review"
        ];
      };
    };

    gui = {pkgs, ...}: let
      inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) ntv;

      ntv-desktop-entry = pkgs.makeDesktopItem {
        name = "nix-search-tv";
        desktopName = "Nix Search TV";
        genericName = "Fuzzy search for Nix packages";
        icon = "dev.vlinkz.NixosConfEditor";
        terminal = true;
        exec = "ntv";
      };
    in {
      hj.packages =
        [ntv]
        ++ [(lib.hiPrio ntv-desktop-entry)];
    };
  };
}
