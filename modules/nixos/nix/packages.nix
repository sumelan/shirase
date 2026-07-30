_: {
  flake.modules.nixos.default = {pkgs, ...}: {
    nixpkgs.overlays = [
      (_: prev: {
        inherit
          (prev.lixPackageSets.latest)
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
        nixpkgs-review = prev.nixpkgs-review.override {withNom = true;};
      })
    ];

    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        nix-init
        nix-output-monitor
        nix-tree
        nix-update
        nixd
        nixfmt
        nixpkgs-review
        ;
    };

    # `pkgs.nixVersions.latest` or `pkgs.lixPackageSets.latest.lix`
    # lix has better Error messages
    nix.package = pkgs.lixPackageSets.latest.lix;

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/nix-search-tv"
        ".cache/nixpkgs-review"
      ];
    };
  };
}
