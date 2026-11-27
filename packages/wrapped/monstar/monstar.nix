{
  self,
  inputs,
  pkgs,
  functions,
  extraConfig ? {},
  extraRuntimeInputs ? [],
}: let
  inherit
    (pkgs.lib)
    recursiveUpdate
    mapAttrsToList
    concatStringsSep
    ;
  inherit (functions.print) wrappedConfig;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) nushell;

  pkg = inputs.monstar.packages.${pkgs.stdenv.hostPlatform.system}.default;

  monstarConfig = let
    cfg = import ./_config.nix {};
    binds = import ./_binds.nix {};

    configLines = mapAttrsToList (k: v: "${k} = ${toString v}") (recursiveUpdate cfg extraConfig);
    bindsLines = mapAttrsToList (k: v: "keybind = ${k}=${v}") binds;
  in
    pkgs.writeText "monstar-wrapped-config" (concatStringsSep "\n" (configLines ++ bindsLines));

  fontDirectories = with pkgs; [
    nerd-fonts._0xproto
  ];

  runtimeEnv = pkgs.buildEnv {
    name = "monstar-runtime-env";
    pathsToLink = ["/bin"];
    paths =
      [
        nushell
      ]
      ++ extraRuntimeInputs;
  };

  printPkg = wrappedConfig monstarConfig {
    name = "monstar-print-config";
    lang = "ini";
  };
in
  pkgs.symlinkJoin {
    name = "monstar";
    paths = [pkg];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      ln -s ${printPkg}/bin/monstar-print-config $out/bin/monstar-print-config

      wrapProgram $out/bin/monstar \
        --add-flags "--config ${monstarConfig}" \
        --prefix PATH : ${runtimeEnv}/bin \
        --set FONTCONFIG_FILE ${pkgs.makeFontsConf {inherit fontDirectories;}}
    '';
    meta = {
      mainProgram = "monstar";
      description = "Wrapped Monstar package with helper scripts to print the config";
    };
  }
