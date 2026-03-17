{lib, ...}: {
  flake.modules.homeManager.default = {
    config,
    pkgs,
    ...
  }: let
    configFile = import ./_config.nix {inherit config lib pkgs;};

    btopPkg = pkgs.symlinkJoin {
      name = "btop";
      paths = [pkgs.btop];
      buildInputs = [pkgs.makeWrapper];
      postBuild =
        # sh
        ''
          wrapProgram $out/bin/btop \
              --add-flags "--config ${configFile}"
        '';

      meta.mainProgram = "btop";
    };
  in {
    home = {
      packages = [btopPkg];
      shellAliases = {
        btop = "btop --preset 0";
      };
    };
  };
}
