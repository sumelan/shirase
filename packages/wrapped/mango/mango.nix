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
  perSystem = {pkgs, ...}: let
    extraConfig = ''
      source-optional = ~/.config/mango/noctalia.conf
    '';
  in {
    packages.mango = mkMango {
      inherit pkgs extraConfig;
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
        (import ./_autostart_sh.nix {inherit lib pkgs;})
        // (import ./_bindings.nix {inherit lib;})
        // (import ./_config.nix {inherit lib;})
        // (import ./_visuals.nix {})
        // (import ./_window.nix {});

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
      extraRuntimeInputs ? [],
    }: let
      local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};

      # mango-config.conf without extraConfig; like `source = foo.conf`
      checkCfg = mkMangoConfig {inherit pkgs topPrefixes bottomPrefixes;};
      cfg = mkMangoConfig {inherit pkgs topPrefixes bottomPrefixes extraConfig;};

      runtimeEnv = pkgs.buildEnv {
        name = "mango-runtime-env";
        pathsToLink = ["/bin"];
        paths =
          builtins.attrValues {
            inherit (pkgs) xdg-desktop-portal-wlr;
            inherit (local) kitty;
          }
          ++ extraRuntimeInputs;
      };

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "mango-print-config";
      };
    in
      pkgs.symlinkJoin {
        name = "mango";
        paths = [pkg];
        nativeBuildInputs = [pkgs.makeWrapper];
        passthru.providedSessions = ["mango"];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          $out/bin/mango -c ${checkCfg} -p

          wrapProgram $out/bin/mango \
            --add-flags "-c ${cfg}" \
            --prefix PATH : ${runtimeEnv}/bin \
            --prefix XCURSOR_PATH : ${pkgs.capitaine-cursors-themed}/share/icons \
            --set XCURSOR_THEME "Capitaine Cursors (Palenight)" \
            --set XCURSOR_SIZE "38"
        '';
        meta.mainProgram = "mango";
      };
  };
}
