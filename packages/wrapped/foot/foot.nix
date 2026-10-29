{
  self,
  pkgs,
  functions,
  extraConfig ? {},
  extraRuntimeInputs ? [],
}: let
  inherit (pkgs.lib) recursiveUpdate;
  inherit (functions.print) wrappedConfig;

  footConfig = let
    iniFmt = pkgs.formats.ini {listsAsDuplicateKeys = true;};
    cfg = import ./_config.nix {inherit pkgs;};
  in
    iniFmt.generate "wrapped-foot.ini" (recursiveUpdate cfg extraConfig);

  fontDirectories = with pkgs; [
    nerd-fonts._0xproto
  ];

  runtimeEnv = pkgs.buildEnv {
    name = "foot-runtime-env";
    pathsToLink = ["/bin"];
    paths = with self.packages.${pkgs.stdenv.hostPlatform.system};
      [
        nushell
      ]
      ++ extraRuntimeInputs;
  };

  printPkg = wrappedConfig footConfig {
    name = "foot-print-config";
    lang = "ini";
  };
in
  pkgs.symlinkJoin {
    name = "foot";
    paths = with pkgs; [foot];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      ln -s ${printPkg}/bin/foot-print-config $out/bin/foot-print-config

      $out/bin/foot --config=${footConfig} --check-config

      wrapProgram $out/bin/foot \
        --add-flags "--config ${footConfig}" \
        --prefix PATH : ${runtimeEnv}/bin \
        --set FONTCONFIG_FILE ${pkgs.makeFontsConf {inherit fontDirectories;}}
    '';
    meta.mainProgram = "foot";
  }
