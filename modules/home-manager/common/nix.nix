{
  pkgs,
  flakePath,
  ...
}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      comma # Runs software without installing it. usage: `, cowsay neato`
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
      checkPhase = ""; # ignore checks since i didn't write this
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
  };

  custom.persist = {
    home.cache.directories = [
      ".cache/nix-index"
      ".cache/nix-search-tv"
    ];
  };
}
