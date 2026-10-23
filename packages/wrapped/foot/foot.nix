{
  pkgs,
  functions,
  extraConfig ? {},
  ...
}: let
  inherit (pkgs.lib) recursiveUpdate;
  inherit (functions.print) wrappedConfig;

  footConfig = let
    iniFmt = pkgs.formats.ini {listsAsDuplicateKeys = true;};
    cfg = import ./_config.nix {};
  in
    iniFmt.generate "wrapped-foot.ini" (recursiveUpdate cfg extraConfig);

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
      cp -r ${printPkg}/bin $out

      $out/bin/foot \
        --config=${footConfig} \
        --check-config

      wrapProgram $out/bin/foot \
        --add-flags "--config ${footConfig}" \
        --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = [pkgs.nerd-fonts._0xproto];}}
    '';
    meta.mainProgram = "foot";
  }
