{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.dms.homeModules.dankMaterialShell];

  options.custom = {
    dms.enable = lib.mkEnableOption "Quickshell for niri";
  };

  config = lib.mkIf config.custom.dms.enable {
    home.packages = with pkgs;
      [
        brightnessctl
        gammastep
        libnotify
      ]
      ++ [inputs.dgop.packages.${system}.default];

    programs.dankMaterialShell = {
      enable = true;
      enableKeybinds = false;
      enableSystemd = false;
      enableSpawn = true;
    };

    programs.niri.settings = {
      binds = {
        "Mod+Space" = {
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "spotlight" "toggle"];
          hotkey-overlay.title = "Application Launcher";
        };
        "Mod+V" = {
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "clipboard" "toggle"];
          hotkey-overlay.title = "Clipboard Manager";
        };
        "Mod+M" = {
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "processlist" "toggle"];
          hotkey-overlay.title = "Task Manager";
        };
        "Mod+N" = {
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "notifications" "toggle"];
          hotkey-overlay.title = "Notification Center";
        };
        "Mod+Comma" = {
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "settings" "toggle"];
          hotkey-overlay.title = "Settings";
        };
        "Mod+Ctrl+L" = {
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "lock" "lock"];
          hotkey-overlay.title = "Lock Screen";
        };
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "audio" "increment" "3"];
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "audio" "decrement" "3"];
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "audio" "mute"];
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "audio" "micmute"];
        };
        "XF86AudioPlay" = {
          allow-when-locked = true;
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "mpris" "playPause"];
        };
        "XF86AudioPause" = {
          allow-when-locked = true;
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "mpris" "playPause"];
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "mpris" "next"];
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "mpris" "previous"];
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "brightness" "increment" "5" "intel_backlight"];
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn = ["qs" "-c" "dms" "ipc" "call" "brightness" "decrement" "5" "intel_backlight"];
        };
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
