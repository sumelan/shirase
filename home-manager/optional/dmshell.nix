{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.dmshell.homeModules.dankMaterialShell];

  options.custom = {
    dmshell.enable = lib.mkEnableOption "Quickshell for niri";
  };

  config = lib.mkIf config.custom.dmshell.enable {
    home.packages = with pkgs; [
      brightnessctl
    ];
    programs.dankMaterialShell = {
      enable = true;
      enableKeybinds = true;
      enableSystemd = false;
      enableSpawn = true;
    };

    programs.niri.settings.binds = {
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = ["qs" "-c" "DankMaterialShell" "ipc" "call" "brightness" "increment" "5"];
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = ["qs" "-c" "DankMaterialShell" "ipc" "call" "brightness" "decrement" "5"];
      };
    };

    custom.persist = {
      home.directories = [
        ".cache/DankMaterialShell"
        ".local/state/DankMaterialShell"
      ];
    };
  };
}
