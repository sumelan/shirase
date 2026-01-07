_: {
  flake.modules.homeManager = {
    default = {pkgs, ...}: {
      home.packages = [pkgs.vesktop];

      custom.persist.home.directories = [
        ".config/vesktop"
      ];
    };

    dissent = {pkgs, ...}: {
      home.packages = [pkgs.dissent];

      custom = {
        persist.home.directories = [
          ".config/dissent"
        ];
        cache.home.directories = [
          ".cache/dissent"
        ];
      };
    };
  };
}
