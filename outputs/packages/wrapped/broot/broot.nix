{config, ...}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: {
    packages.broot = config.flake.custom.wrappers.mkBroot {
      inherit pkgs;
    };
  };

  flake.custom.wrappers = {
    mkBrootConfig = {
      pkgs,
      extraConfig ? {},
    }: let
      inherit (pkgs) lib;
      jsonFmt = pkgs.formats.json {};
      cfg = import ./_config.nix {};

      toBrootConfig = pkgs.symlinkJoin {
        name = "toBrootConfig";
        paths = [
          # Copy all files under /resources/default-conf
          "${pkgs.broot.src}/resources/default-conf"
          # Dummy file to prevent broot from trying to reinstall itself
          (pkgs.writeTextDir "launcher/installed-v1" "")
        ];
        postBuild = ''
          rm $out/conf.hjson
          ${lib.getExe pkgs.jq} --slurp add > $out/conf.hjson \
            <(${lib.getExe pkgs.hjson-go} -c ${pkgs.broot.src}/resources/default-conf/conf.hjson) \
            ${jsonFmt.generate "broot-config.json" (cfg // extraConfig)}
        '';
      };
    in "${toBrootConfig}/conf.hjson";

    mkBroot = {
      pkgs,
      extraConfig ? {},
    }: let
      cfg = config.flake.custom.wrappers.mkBrootConfig {
        inherit pkgs extraConfig;
      };

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "broot-print-config";
        lang = "json";
      };
    in
      pkgs.symlinkJoin {
        name = "broot";
        paths = with pkgs; [broot];
        nativeBuildInputs = with pkgs; [makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/broot \
            --add-flags "--conf ${cfg}"
        '';
        meta.mainProgram = "broot";
      };
  };
}
