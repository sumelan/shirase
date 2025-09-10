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
    singleton
    ;
  cfg = config.programs.dankMaterialShell;
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
        enableSystemd = true;
        enableSpawn = false;
      };
      niri.settings = {
        layer-rules = [
          {
            matches = singleton {
              namespace = "^quickshell$";
            };
            place-within-backdrop = true;
          }
        ];
      };
    };

    systemd.user.services.quickshell = mkIf cfg.enableSystemd {
      Service = {
        Environment = [
          "QT_QPA_PLATFORM=wayland"
          "ELECTRON_OZONE_PLATFORM_HINT=auto"
        ];
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
