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
      gammastep
      glib
    ];

    programs.dankMaterialShell = {
      enable = true;
      enableKeybinds = true;
      enableSystemd = false;
      enableSpawn = true;
    };

    programs.niri.settings.binds = {
      "Mod+N" = {
        action.spawn = ["qs" "-c" "DankMaterialShell" "ipc" "call" "notifications" "toggle"];
        hotkey-overlay.title = "Notification Center";
      };
      "XF86AudioPlay" = {
        allow-when-locked = true;
        action.spawn = ["qs" "-c" "DankMaterialShell" "ipc" "call" "mpris" "playPause"];
      };
      "XF86AudioPause" = {
        allow-when-locked = true;
        action.spawn = ["qs" "-c" "DankMaterialShell" "ipc" "call" "mpris" "playPause"];
      };
      "XF86AudioNext" = {
        allow-when-locked = true;
        action.spawn = ["qs" "-c" "DankMaterialShell" "ipc" "call" "mpris" "next"];
      };
      "XF86AudioPrev" = {
        allow-when-locked = true;
        action.spawn = ["qs" "-c" "DankMaterialShell" "ipc" "call" "mpris" "previous"];
      };
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = ["qs" "-c" "DankMaterialShell" "ipc" "call" "brightness" "increment" "5" "intel_backlight"];
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = ["qs" "-c" "DankMaterialShell" "ipc" "call" "brightness" "decrement" "5" "intel_backlight"];
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
