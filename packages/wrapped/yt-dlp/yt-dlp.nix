{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: {
    packages.yt-dlp = config.flake.custom.wrappers.mkYtdlp {
      inherit pkgs;
    };
  };

  flake.custom.wrappers = let
    singleOption = name: value: let
      isShort = builtins.stringLength name == 1;
      prefix =
        if isShort
        then "-"
        else "--";
    in
      if lib.isBool value
      then
        if value
        then "${prefix}${name}"
        else if isShort
        then ""
        else "--no-${name}"
      else "${prefix}${name} ${toString value}";

    toYtdlpConf = settings:
      lib.pipe settings [
        (lib.mapAttrsToList (
          name: value:
            if lib.isList value
            then (map (singleOption name) value)
            else [(singleOption name value)]
        ))
        builtins.concatLists
        (lib.remove "")
        (lib.concatStringsSep "\n")
      ];
  in {
    mkYtdlpConfig = {
      pkgs,
      extraConfig ? {},
    }:
      pkgs.writeTextFile {
        name = "yt-dlp.conf";
        text = toYtdlpConf (import ./_config.nix {} // extraConfig);
      };

    mkYtdlp = {
      pkgs,
      extraConfig ? {},
    }: let
      cfg = config.flake.custom.wrappers.mkYtdlpConfig {
        inherit pkgs extraConfig;
      };

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "yt-dlp-print-config";
        lang = "ini";
      };
    in
      pkgs.symlinkJoin {
        name = "yt-dlp";
        paths = [pkgs.yt-dlp];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/yt-dlp \
            --add-flags "--config-location ${cfg}"
        '';
        meta.mainProgram = "yt-dlp";
      };
  };
}
