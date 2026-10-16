{config, ...}: let
  inherit (config.flake.custom.functions) printConfig;
  inherit (config.flake.custom.lib.recursiveMerge {}) attrsList;
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
      cfg = attrsList [
        (import ./_config.nix {})
        (import ./_skin.nix {})
        (import ./_verbs.nix {})
      ];

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

          ${lib.getExe pkgs.hjson-go} \
            ${jsonFmt.generate "broot-config.json" (cfg // extraConfig)} \
              > $out/conf.hjson
        '';
      };
    in
      toBrootConfig + "/conf.hjson";

    mkBroot = {
      pkgs,
      extraRuntimeInputs ? [],
      extraConfig ? {},
    }: let
      runtimeEnv = pkgs.buildEnv {
        name = "broot-runtime-env";
        pathsToLink = ["/bin"];
        paths = with pkgs;
          [
            direnv
            unar
            ripdrag
          ]
          ++ extraRuntimeInputs;
      };

      cfg = config.flake.custom.wrappers.mkBrootConfig {
        inherit pkgs extraConfig;
      };

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "broot-print-config";
      };
    in
      pkgs.symlinkJoin {
        name = "broot";
        paths = with pkgs; [broot];
        nativeBuildInputs = with pkgs; [makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/broot \
            --prefix PATH : ${runtimeEnv}/bin \
            --add-flags "--conf ${cfg}"
        '';
        meta.mainProgram = "broot";
      };
  };
}
