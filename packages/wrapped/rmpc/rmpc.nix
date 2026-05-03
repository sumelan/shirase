{config, ...}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: {
    packages.rmpc = config.flake.custom.wrappers.mkRmpc {
      inherit pkgs;
    };
  };

  # TODO: add `--config` flags after v0.12 released
  flake.custom.wrappers = {
    rmpcTheme = {pkgs}:
      import ./_theme.nix {inherit pkgs;};

    mkRmpc = {pkgs}: let
      theme = config.flake.custom.wrappers.rmpcTheme {inherit pkgs;};

      printCfg = printConfig {
        inherit pkgs;
        name = "rmpc-print-theme";
        cfg = theme;
        lang = "ron";
      };
    in
      pkgs.symlinkJoin {
        name = "rmpc";
        paths = [pkgs.rmpc];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/rmpc \
            --add-flags "--theme ${theme}"
        '';
      };
  };
}
