{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.wrappers) mkHelixConfig mkHelixLanguages;
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: {
    packages.helix = config.flake.custom.wrappers.mkHelix {
      inherit pkgs;
    };
  };

  flake.custom.wrappers = {
    mkHelixLanguages = {
      pkgs,
      extraLang,
    }:
      pkgs.writers.writeTOML "helix-languages" (
        lib.recursiveUpdate
        (import ./_languages.nix {inherit pkgs lib;})
        extraLang
      );

    mkHelixConfig = {
      pkgs,
      extraCfg,
    }:
      pkgs.writers.writeTOML "helix-config" (
        lib.recursiveUpdate
        (import ./_config.nix {})
        extraCfg
      );

    mkHelix = {
      pkgs,
      pkg ? pkgs.helix,
      extraRuntimeInputs ? [],
      extraCfg ? {},
      extraLang ? {},
    }: let
      runtimeEnv = pkgs.buildEnv {
        name = "helix-runtime-env";
        pathsToLink = ["/bin"];

        paths = builtins.attrValues ({
            inherit
              (pkgs)
              # Nix
              alejandra
              nixd
              # Rust
              rust-analyzer
              rustfmt
              # Python
              ruff
              basedpyright
              # Yaml/json
              biome
              yaml-language-server
              vscode-json-languageserver
              ;
          }
          // {
            inherit extraRuntimeInputs;
          });
      };

      cfg = mkHelixConfig {inherit pkgs extraCfg;};
      langs = mkHelixLanguages {inherit pkgs extraLang;};

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "hx-print-config";
        lang = "toml";
      };

      printLangs = printConfig {
        inherit pkgs;
        name = "hx-print-languages";
        cfg = langs;
        lang = "toml";
      };
    in
      pkgs.symlinkJoin {
        name = "hx";
        paths = [pkg];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out
          cp -r ${printLangs}/bin $out

          mkdir -p $out/helix/themes
          ln -s ${cfg} $out/helix/config.toml
          ln -s ${langs} $out/helix/languages.toml
          wrapProgram $out/bin/hx \
            --prefix PATH : ${runtimeEnv}/bin \
            --set XDG_CONFIG_HOME $out
        '';
        meta.mainProgram = "hx";
      };
  };
}
