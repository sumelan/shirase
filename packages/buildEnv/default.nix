{config, ...}: {
  perSystem = {pkgs, ...}: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};

    commonPkgs = builtins.attrValues {
      inherit (local) nushell;
      inherit (local) helix;
      inherit (local) ns;
    };
  in {
    packages = {
      termEnv = pkgs.buildEnv {
        # Extra packages for CLI hosts like development servers
        name = "Terminal env";
        paths = commonPkgs;
      };

      fullEnv = pkgs.buildEnv {
        # Fully loaded graphical environments
        name = "Full env";
        paths =
          builtins.attrValues {
            inherit (pkgs) brave-origin;
            inherit
              (local)
              foot
              ;
          }
          ++ commonPkgs;
      };
    };
  };
}
