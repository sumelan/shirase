{
  config,
  lib,
  ...
}: let
  inherit
    (config.flake.custom.wrappers)
    mkNushell
    mkNuConfig
    mkNuEnvConfig
    mkStarshipConfig
    ;
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: {
    packages.nushell = mkNushell {
      inherit pkgs;
      env = {
        STARSHIP_CONFIG = mkStarshipConfig {
          inherit pkgs;
          nf-icon = "󰟆 ";
        };
      };
    };
  };

  flake.custom.wrappers = {
    mkNuConfig = {
      pkgs,
      extraAliases ? {},
      extraConfig ? "",
    }: let
      inherit (config.flake.custom.userModules.shellAliases) basic nu extra;
      mergedAliases = basic // extra // nu // extraAliases;
      aliases = lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "alias ${k} = ${v}") mergedAliases);
    in
      pkgs.writeText "nu-config" (
        (builtins.readFile ./config.nu)
        + (builtins.readFile ./tack.nu)
        + (builtins.readFile ./starship.nu)
        +
        # nu
        ''
          source ${
            pkgs.runCommand "carapace-nushell-config.nu" {} ''
              ${lib.getExe pkgs.carapace} _carapace nushell | sed 's|"/homeless-shelter|$"($env.HOME)|g' >> "$out"
            ''
          }
        ''
        +
        # nu
        ''
          source ${
            pkgs.runCommand "nix-your-shell-nushell-config.nu" {} ''
              ${lib.getExe pkgs.nix-your-shell} --nom nu >> "$out"
            ''
          }
        ''
        + extraConfig
        + aliases
      );

    mkNuEnvConfig = {
      pkgs,
      env ? {},
      extraConfig ? "",
    }: let
      envAttrs =
        (lib.concatStringsSep "\n" (
          lib.mapAttrsToList (k: v: "$env.${k} = ${builtins.toJSON v}") env
        ))
        + "\n";
    in
      pkgs.writeText "nu-env-config" (envAttrs + extraConfig);

    mkNushell = {
      pkgs,
      env ? {},
      extraConfig ? "",
      extraAliases ? {},
      extraRuntimeInputs ? [],
    }: let
      local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};

      runtimeEnv = pkgs.buildEnv {
        name = "nushell-runtime-env";
        pathsToLink = ["/bin"];

        paths =
          builtins.attrValues {
            inherit
              (pkgs)
              # Shell Utilities
              carapace
              carapace-bridge
              direnv
              nix-direnv
              nix-your-shell
              starship
              # Command Line
              fd
              fzf
              jq
              # VCS
              git
              delta
              tig
              lazygit
              ;
            inherit (local) bat eza moor ripgrep;
          }
          ++ extraRuntimeInputs;
      };

      cfg = mkNuConfig {inherit pkgs extraAliases extraConfig;};
      envCfg = mkNuEnvConfig {inherit pkgs env;};

      printCfg = printConfig {
        inherit cfg pkgs;
        lang = "nu";
        name = "nu-print-config";
      };

      printEnv = printConfig {
        inherit pkgs;
        name = "nu-print-env";
        cfg = envCfg;
      };
    in
      pkgs.symlinkJoin {
        name = "nu";
        paths = [pkgs.nushell];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out
          cp -r ${printEnv}/bin $out

          wrapProgram $out/bin/nu \
            --add-flags "--config ${cfg} --env-config ${envCfg}" \
            --prefix PATH : ${runtimeEnv}/bin
        '';
        passthru.shellPath = "/bin/nu";
        meta.mainProgram = "nu";
      };
  };
}
