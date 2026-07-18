{config, ...}: {
  perSystem = {pkgs, ...}: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};

    commonPkgs = builtins.attrValues {
      inherit (local) bat batman eza eza-tree moor ripgrep difftastic;
      inherit (local) btop rmpc starship yt-dlp;
      inherit (local) nushell;
      inherit (local) nvf;
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
            inherit (local) ghostty;
          }
          ++ commonPkgs;
      };
    };
  };
}
