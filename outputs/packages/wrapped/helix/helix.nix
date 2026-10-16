{config, ...}: let
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
    }: let
      inherit (pkgs) lib;
    in
      pkgs.writers.writeTOML "helix-languages" (
        lib.recursiveUpdate
        (import ./_languages.nix {})
        extraLang
      );

    mkHelixConfig = {
      pkgs,
      extraConfig,
    }: let
      inherit (pkgs) lib;
    in
      pkgs.writers.writeTOML "helix-config" (
        lib.recursiveUpdate
        (import ./_config.nix {})
        extraConfig
      );

    mkHelix = {
      pkgs,
      extraRuntimeInputs ? [],
      extraConfig ? {},
      extraLang ? {},
    }: let
      runtimeEnv = pkgs.buildEnv {
        name = "helix-runtime-env";
        pathsToLink = ["/bin"];
        paths = with pkgs;
          [
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
          ]
          ++ extraRuntimeInputs;
      };

      cfg = mkHelixConfig {inherit pkgs extraConfig;};
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
        paths = with pkgs; [helix];
        nativeBuildInputs = with pkgs; [makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out
          cp -r ${printLangs}/bin $out

          rm $out/bin/.hx-wrapped

          mkdir -p $out/helix

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
