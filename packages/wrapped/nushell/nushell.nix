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
  perSystem = {pkgs, ...}: let
    dotfile = "/home/sumelan/Projects/shirase";
  in {
    packages.nushell = mkNushell {
      inherit pkgs;
      env = {
        NH_FLAKE = dotfile;
        NIXPKGS_ALLOW_UNFREE = "1";
        STARSHIP_CONFIG = mkStarshipConfig {
          inherit pkgs;
          nf-icon = "󱏳 ";
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
        + (builtins.readFile ./starship.nu)
        + ''
          source $"($nu.cache-dir)/carapace.nu"
        ''
        + extraConfig
        + aliases
      );

    mkNuEnvConfig = {
      pkgs,
      env ? {},
      extraConfig ? "",
    }: let
      completions = ''
        $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
        mkdir $"($nu.cache-dir)"
        carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
        mkdir ('~/.config/nushell' | path expand)
        touch ('~/.config/nushell/host.nu' | path expand)
      '';
      envAttrs =
        (lib.concatStringsSep "\n" (
          lib.mapAttrsToList (k: v: "$env.${k} = ${builtins.toJSON v}") env
        ))
        + "\n";
    in
      pkgs.writeText "nu-env-config" (envAttrs + completions + extraConfig);

    mkNushell = {
      pkgs,
      env ? {},
      extraConfig ? "",
      extraAliases ? {},
      extraRuntimeInputs ? [],
    }: let
      runtimeEnv = pkgs.buildEnv {
        name = "nushell-runtime-env";
        pathsToLink = ["/bin"];

        paths = with pkgs;
          [
            starship
            # Shell Utilities
            carapace
            carapace-bridge
            direnv
            nix-direnv
            # Command Line
            bat
            eza
            fd
            fzf
            jq
            ripgrep
            # VCS
            git
            delta
            tig
            lazygit
          ]
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
