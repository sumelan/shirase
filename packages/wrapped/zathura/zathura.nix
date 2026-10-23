{
  pkgs,
  functions,
  extraRawConfig ? "",
  ...
}: let
  inherit
    (pkgs.lib)
    isBool
    concatStringsSep
    mapAttrsToList
    ;
  inherit (functions.print) wrappedConfig;

  zathuraConfig = let
    cfg = import ./_config.nix {};
    mapping = import ./_mappings.nix {};

    formatLine = n: v: let
      formatValue = v:
        if isBool v
        then
          (
            if v
            then "true"
            else "false"
          )
        else toString v;
    in ''set ${n}	"${formatValue v}"'';

    formatMapLine = n: v: "map ${n} ${toString v}";
  in
    pkgs.writeTextFile {
      name = "zathura";
      destination = "/zathurarc";
      text = ''
        ${concatStringsSep "\n" (
          mapAttrsToList formatLine cfg
          ++ mapAttrsToList formatMapLine mapping
        )}
        ${extraRawConfig}
      '';
    };

  printPkg = wrappedConfig (zathuraConfig + "/zathurarc") {
    name = "zathura-print-config";
    lang = "ini";
  };
in
  pkgs.symlinkJoin {
    name = "zathura";
    paths = with pkgs; [zathura];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      ln -s ${printPkg}/bin/zathura-print-config $out/bin/zathura-print-config

      wrapProgram $out/bin/zathura \
        --add-flags "--config-dir ${zathuraConfig}"
    '';
    meta.mainProgram = "zathura";
  }
