{
  flake.custom.functions.printConfig = {
    pkgs,
    name,
    cfg,
    lang ? "",
  }: let
    flags =
      if lang == ""
      then ""
      else "--lang ${lang}";
  in
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [pkgs.bat];
      text = ''
        moor ${flags} "$@" ${cfg}
      '';
    };
}
