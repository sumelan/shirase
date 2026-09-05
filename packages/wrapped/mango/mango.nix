{
  inputs,
  config,
  lib,
  ...
}: let
  inherit
    (config.flake.custom.wrappers)
    mkMango
    mkMangoConfig
    ;
  inherit (config.flake.custom.functions) printConfig;
  mlib = import "${inputs.mangowm}/nix/lib.nix" lib;
in {
  perSystem = {pkgs, ...}: {
    packages.mango = mkMango {
      inherit pkgs;
      pkg = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };

  flake.custom.wrappers = {
    mkMangoConfig = {
      pkgs,
      # List of prefixes for attributes that should appear at the top of the config file.
      # Attributes starting with these prefixes will be sorted to the beginning.
      topPrefixes ? [],
      # List of prefixes for attributes that should appear at the bottom of the config file.
      # Attributes starting with these prefixes will be sorted to the end.
      bottomPrefixes ? [],
      extraConfig ? "",
    }: let
      settings =
        (import ./_config.nix {inherit lib;})
        // (import ./_keybinds.nix {inherit lib;})
        // (import ./_autostart_sh.nix {inherit lib pkgs;});

      finalConfigText =
        (
          mlib.toMango {
            topCommandsPrefixes = topPrefixes;
            bottomCommandsPrefixes = bottomPrefixes;
          }
          settings
        )
        + extraConfig;
    in
      pkgs.writeText "mango-config.conf" finalConfigText;

    mkMango = {
      pkg ? pkgs.mango,
      pkgs,
      extraConfig ? "",
      topPrefixes ? [],
      bottomPrefixes ? [],
    }: let
      cfg = mkMangoConfig {inherit pkgs topPrefixes bottomPrefixes extraConfig;};

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "mango-print-config";
      };
    in
      pkgs.symlinkJoin {
        name = "mango";
        paths = [pkg];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          $out/bin/mango -c ${cfg} -p

          wrapProgram $out/bin/mango \
            --add-flags "-c ${cfg}"
        '';
        passthru = {
          providedSessions = ["mango"];
        };
        meta.mainProgram = "mango";
      };
  };
}
