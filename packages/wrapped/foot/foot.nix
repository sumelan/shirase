{
  pkgs,
  functions,
  ...
}: let
  inherit (pkgs.lib) recursiveUpdate;
  inherit (functions.print) wrappedConfig;

  footConfig = let
    iniFmt = pkgs.formats.ini {listsAsDuplicateKeys = true;};
    cfg = import ./_config.nix {};

    extraConfig = {
      main = {
        shell = "nu";
        include = pkgs.foot.themes + "/share/foot/themes/catppuccin-frappe";
      };
    };
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
      ln -s ${printPkg}/bin/foot-print-config $out/bin/foot-print-config

      $out/bin/foot --config=${footConfig} --check-config

      wrapProgram $out/bin/foot \
        --add-flags "--config ${footConfig}" \
        --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = [pkgs.nerd-fonts._0xproto];}}
    '';
    meta.mainProgram = "foot";
  }
