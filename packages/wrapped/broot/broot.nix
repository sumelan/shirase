{
  pkgs,
  functions,
  extraConfig ? {},
  extraRuntimeInputs ? [],
}: let
  inherit (pkgs.lib) getExe recursiveUpdate;
  inherit (functions.recursive) attrsList;
  inherit (functions.print) wrappedConfig;

  brootConfig = let
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

        ${getExe pkgs.hjson-go} \
          ${jsonFmt.generate "broot-config.json" (recursiveUpdate cfg extraConfig)} \
            > $out/conf.hjson
      '';
    };
  in
    toBrootConfig + "/conf.hjson";

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

  printPkg = wrappedConfig brootConfig {
    name = "broot-print-config";
  };
in
  pkgs.symlinkJoin {
    name = "broot";
    paths = with pkgs; [broot];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      ln -s ${printPkg}/bin/broot-print-config $out/bin/broot-print-config

      wrapProgram $out/bin/broot \
        --prefix PATH : ${runtimeEnv}/bin \
        --add-flags "--conf ${brootConfig}"
    '';
    meta.mainProgram = "broot";
  }
