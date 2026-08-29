{config, ...}: {
  flake.custom.functions.printConfig = {
    pkgs,
    name,
    cfg,
    lang ? "",
  }: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
    flags =
      if lang == ""
      then ""
      else "--language ${lang}";
  in
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [local.bat];
      text = ''
        bat ${flags} "$@" ${cfg}
      '';
    };
}
