{
  pkgs,
  functions,
  extraConfig ? {},
  extraLang ? {},
  extraRuntimeInputs ? [],
  ...
}: let
  inherit (pkgs.lib) recursiveUpdate;
  inherit (functions.print) wrappedConfig;

  helixConfig = let
    cfg = import ./_config.nix {};
  in
    pkgs.writers.writeTOML "helix-config" (recursiveUpdate cfg extraConfig);

  helixLanguage = let
    lang = import ./_languages.nix {};
  in
    pkgs.writers.writeTOML "helix-languages" (recursiveUpdate lang extraLang);

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

  printPkg = wrappedConfig helixConfig {
    name = "hx-print-config";
    lang = "toml";
  };

  printLangPkg = wrappedConfig helixLanguage {
    name = "hx-print-languages";
    lang = "toml";
  };
in
  pkgs.symlinkJoin {
    name = "hx";
    paths = with pkgs; [helix];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      cp -r ${printPkg}/bin $out
      cp -r ${printLangPkg}/bin $out

      rm $out/bin/.hx-wrapped

      mkdir -p $out/helix

      ln -s ${helixConfig} $out/helix/config.toml
      ln -s ${helixLanguage} $out/helix/languages.toml

      wrapProgram $out/bin/hx \
        --prefix PATH : ${runtimeEnv}/bin \
        --set XDG_CONFIG_HOME $out
    '';
    meta.mainProgram = "hx";
  }
