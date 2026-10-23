{
  pkgs,
  functions,
  pkg ? pkgs.btop,
  extraConfig ? {},
  ...
}: let
  inherit (pkgs.lib) recursiveUpdate;
  inherit
    (pkgs.lib.generators)
    toKeyValue
    mkKeyValueDefault
    ;
  inherit (functions.print) wrappedConfig;

  btopConfig = let
    cfg = import ./_config.nix {};
    toBtopConf = toKeyValue {
      mkKeyValue = mkKeyValueDefault {
        mkValueString = v:
          if builtins.isBool v
          then
            (
              if v
              then "True"
              else "False"
            )
          else if builtins.isString v
          then ''"${v}"''
          else toString v;
      } " = ";
    };
  in
    pkgs.writeTextFile {
      name = "wrapped-btop.conf";
      text = toBtopConf (recursiveUpdate cfg extraConfig);
    };

  theme = import ./_theme.nix {inherit pkgs;};

  printPkg = wrappedConfig btopConfig {
    name = "btop-print-config";
    lang = "ini";
  };
in
  pkgs.symlinkJoin {
    name = "btop";
    paths = [pkg];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      cp -r ${printPkg}/bin $out

      ln -s ${theme} $out/share/btop/themes/catppuccin-frappe.theme

      wrapProgram $out/bin/btop \
        --add-flags "--config ${btopConfig}" \
        --add-flags "--themes-dir $out/share/btop/themes"
    '';
    meta.mainProgram = "btop";
  }
