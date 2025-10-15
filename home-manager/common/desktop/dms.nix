{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    getExe
    getExe'
    ;
in {
  options.custom = {
    dms.enable = mkEnableOption "DankMaterialShell";
  };

  config = mkIf config.custom.dms.enable {
    programs = {
      dankMaterialShell = {
        enable = true;
      };
    };

    niri.settings.spawn-at-startup = [
      # clipboard manager
      {sh = "${getExe' pkgs.wl-clipboard "wl-paste"} --watch ${getExe pkgs.cliphist} store &";}
    ];
  };
}
