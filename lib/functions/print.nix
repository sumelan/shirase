{
  self,
  pkgs,
}: {
  wrappedConfig = cfg: {
    name,
    lang ? "",
  }: let
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) bat;
    flags =
      if lang == ""
      then ""
      else "--language ${lang}";
  in
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [bat];
      text = ''
        bat ${flags} "$@" ${cfg}
      '';
    };
}
