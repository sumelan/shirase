{config, ...}: {
  perSystem = {pkgs, ...}: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};

    commonPkgs = builtins.attrValues {
      inherit
        (local)
        #  nushell
        #  fish
        helix
        #  ns
        ;
    };
  in {
    packages = {
      termEnv = pkgs.buildEnv {
        # Extra packages for CLI hosts like development servers
        name = "Sumelan's terminal env";
        paths = commonPkgs;
      };

      fullEnv = pkgs.buildEnv {
        # Fully loaded graphical environments
        name = "Sumelan's full env";
        paths = with local;
          [
            ghostty
            helium
            foot
            kitty
          ]
          ++ commonPkgs;
      };
    };
  };
}
