{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: let
    extraConfig = {
      main = {
        shell = "fish";
        include = "${pkgs.foot.themes}/share/foot/themes/nord";
      };
    };
  in {
    packages.foot = config.flake.custom.wrappers.mkFoot {
      inherit pkgs extraConfig;
    };
  };

  flake.custom.wrappers = {
    mkFootConfig = {
      pkgs,
      extraConfig ? {},
    }: let
      iniFmt = pkgs.formats.ini {listsAsDuplicateKeys = true;};
      cfg = import ./_config.nix {};
    in
      iniFmt.generate "wrapped-foot.ini" (lib.recursiveUpdate cfg extraConfig);

    mkFoot = {
      pkgs,
      extraConfig ? {},
    }: let
      cfg = config.flake.custom.wrappers.mkFootConfig {
        inherit pkgs extraConfig;
      };

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "foot-print-config";
        lang = "ini";
      };
    in
      pkgs.symlinkJoin {
        name = "foot";
        paths = [pkgs.foot];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          $out/bin/foot \
            --config=${cfg} \
            --check-config

          wrapProgram $out/bin/foot \
            --add-flags "--config ${cfg}" \
            --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = [pkgs.maple-mono.NF-unhinted];}}
        '';
        meta.mainProgram = "foot";
      };
  };
}
