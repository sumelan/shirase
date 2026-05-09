{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  perSystem = {pkgs, ...}: {
    packages = {
      zeditor = flake.custom.wrappers.mkZeditor {inherit pkgs;};
      zedConfig = flake.custom.wrappers.mkZedConfig {inherit pkgs;};

      zedPkgs = pkgs.buildEnv {
        name = "zed-runtimeenv";
        pathsToLink = ["/bin"];
        paths = with pkgs; [
          # Nix
          alejandra
          nil
          nixd
          statix

          # Go
          go
          gopls
          gofumpt

          # Rust
          rust-analyzer
          rustfmt

          # Python
          python3
          ruff
          basedpyright

          # Yaml
          yaml-language-server
        ];
      };
    };
  };

  flake.custom.wrappers = {
    mkZeditor = {pkgs}:
      pkgs.symlinkJoin {
        name = "zeditor";
        paths = [pkgs.zed-editor];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/zeditor \
            --prefix PATH : ${flake.packages.${pkgs.stdenv.hostPlatform.system}.zedPkgs}/bin \
            --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = with pkgs; [ibm-plex lilex];}}
        '';
      };

    mkZedConfig = {
      pkgs,
      extraConfig ? {},
    }:
      pkgs.runCommand "zed-settings.json" {
        nativeBuildInputs = [pkgs.biome];
        json = builtins.toJSON (lib.recursiveUpdate (import ./_config.nix {}) extraConfig);
        passAsFile = ["json"];
      } ''
        biome format --stdin-file-path settings.json < "$jsonPath" > $out
      '';
  };
}
