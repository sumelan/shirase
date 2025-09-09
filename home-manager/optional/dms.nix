{
  lib,
  config,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkForce
    ;
in {
  imports = [inputs.dms.homeModules.dankMaterialShell];

  options.custom = {
    dms.enable = mkEnableOption "Quickshell for niri";
  };

  config = mkIf config.custom.dms.enable {
    programs = {
      dankMaterialShell = {
        enable = true;
        enableKeybinds = true;
        enableSystemd = mkForce false;
        enableSpawn = true;
      };
    };

    custom.persist = {
      home.directories = [
        ".config/DankMaterialShell"
        ".local/state/DankMaterialShell"
      ];
    };
  };
}
