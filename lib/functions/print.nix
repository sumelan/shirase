{pkgs, ...}: {
  wrappedConfig = cfg: {
    name,
    lang ? "",
  }: let
    flags =
      if lang == ""
      then ""
      else "--language ${lang}";
  in
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = with pkgs; [bat];
      text = ''
        bat ${flags} "$@" ${cfg}
      '';
    };
}
