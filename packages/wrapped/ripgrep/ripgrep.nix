{config, ...}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: {
    packages.ripgrep = config.flake.custom.wrappers.mkRipgrep {
      inherit pkgs;
    };
  };

  flake.custom.wrappers = {
    ignoreFiles = {
      pkgs,
      extraFiles ? "",
    }:
      import ./_ignoreFile.nix {inherit pkgs extraFiles;};

    mkRipgrep = {
      pkgs,
      extraFiles ? "",
    }: let
      cfg = config.flake.custom.wrappers.ignoreFiles {
        inherit pkgs extraFiles;
      };

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "ripgrep-print-ignorefiles";
      };
    in
      pkgs.symlinkJoin {
        name = "rg";
        paths = [pkgs.ripgrep];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/rg \
            --add-flags "--smart-case" \
            --add-flags "--ignore-file ${cfg}"
        '';
        meta.mainProgram = "rg";
      };
  };
}
