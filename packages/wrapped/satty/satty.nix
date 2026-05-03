{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: {
    packages.satty = config.flake.custom.wrappers.mkSatty {
      inherit pkgs;
    };
  };

  flake.custom.wrappers = {
    mkSattyConfig = {
      pkgs,
      extraConfig ? {},
    }:
      pkgs.writers.writeTOML "wrapperd-satty.toml" (
        lib.recursiveUpdate
        (import ./_config.nix {})
        extraConfig
      );

    mkSatty = {
      pkgs,
      extraConfig ? {},
    }: let
      cfg = config.flake.custom.wrappers.mkSattyConfig {
        inherit pkgs extraConfig;
      };

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "satty-print-config";
        lang = "toml";
      };
    in
      pkgs.symlinkJoin {
        name = "satty";
        paths = [pkgs.satty];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/satty \
            --add-flags "--config ${cfg}"
        '';
        meta.mainProgram = "satty";
      };
  };
}
