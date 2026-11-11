{
  self,
  pkgs,
}: {
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
      runtimeInputs = [self.packages.${pkgs.stdenv.hostPlatform.system}.bat];
      text = ''
        bat ${flags} "$@" ${cfg}
      '';
    };
}
