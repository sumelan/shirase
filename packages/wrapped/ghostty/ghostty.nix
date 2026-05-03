{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.wrappers) mkGhosttyConfig;
  inherit (config.flake.custom.functions) printConfig;
  cfg = import ./_config.nix {};
  binds = import ./_binds.nix {};
in {
  perSystem = {pkgs, ...}: let
    pkg = pkgs.ghostty;
    extraConfig = {
      command = "fish";
      window-decoration = "none";
    };
  in {
    packages = {
      ghostty = config.flake.custom.wrappers.mkGhostty {
        inherit pkg pkgs extraConfig;
      };
    };
  };

  flake.custom.wrappers = {
    mkGhosttyConfig = {
      pkgs,
      extraConfig ? {},
      extraBinds ? {},
    }: let
      allConfig = cfg // extraConfig;
      allBinds = binds // extraBinds;
      configLines = lib.mapAttrsToList (k: v: "${k} = ${toString v}") allConfig;
      bindsLines = lib.mapAttrsToList (k: v: "keybind = ${k}=${v}") allBinds;
    in
      pkgs.writeText "ghostty-wrapped-config" (lib.concatStringsSep "\n" (configLines ++ bindsLines));

    mkGhostty = {
      pkgs,
      pkg ? pkgs.ghostty,
      extraConfig ? {},
      extraBinds ? {},
    }: let
      cfg = mkGhosttyConfig {inherit pkgs extraConfig extraBinds;};

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "ghostty-print-config";
        lang = "ini";
      };
    in
      pkgs.symlinkJoin {
        name = "ghostty";
        paths = [pkg];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/ghostty \
            --add-flags "--config-file=${cfg}" \
            --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = [pkgs.maple-mono.NF-unhinted];}}
        '';
        meta.mainProgram = "ghostty";
      };
  };
}
