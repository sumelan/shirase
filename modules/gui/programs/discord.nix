_: {
  flake.modules.homeManager.default = {pkgs, ...}: {
    home.packages = [
      pkgs.vesktop
      pkgs.dissent
    ];

    custom = {
      persist.home.directories = [
        ".config/vesktop"
        ".config/dissent"
      ];
      cache.home.directories = [
        ".cache/dissent"
      ];
    };
  };
}
