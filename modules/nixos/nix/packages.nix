{
  config,
  lib,
  ...
}: {
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
  };
}
