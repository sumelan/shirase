{lib, ...}: let
  inherit (lib) singleton;
  inherit (lib.custom.colors) blue0;
  inherit (lib.custom.niri) spawn hotkey;
in {
  programs = {
    dankMaterialShell = {
      default = {
        settings = {};
      };
      plugins = {};
    };

    niri.settings = {
      binds = {
        "Mod+Space" = {
          action.spawn = spawn "dms ipc spotlight toggle";
          hotkey-overlay.title = hotkey {
            color = blue0;
            name = "DankMaterialShell";
            text = "Launcher";
          };
        };
        "Mod+N" = {
          action.spawn = spawn "dms ipc notifications toggle";
          hotkey-overlay.title = hotkey {
            color = blue0;
            name = "DankMaterialShell";
            text = "Notifications";
          };
        };
        "Mod+Comma" = {
          action.spawn = spawn "dms ipc settings toggle";
          hotkey-overlay.title = hotkey {
            color = blue0;
            name = "DankMaterialShell";
            text = "Settings";
          };
        };
        "Mod+P" = {
          action.spawn = spawn "dms ipc notepad toggle";
          hotkey-overlay.title = hotkey {
            color = blue0;
            name = "DankMaterialShell";
            text = "Notepad";
          };
        };
        "Mod+Alt+L" = {
          action.spawn = spawn "dms ipc lock lock";
          hotkey-overlay.title = hotkey {
            color = blue0;
            name = "DankMaterialShell";
            text = "Lock Screen";
          };
        };
        "Mod+X" = {
          action.spawn = spawn "dms ipc powermenu toggle";
          hotkey-overlay.title = hotkey {
            color = blue0;
            name = "DankMaterialShell";
            text = "Power Menu";
          };
        };
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = spawn "dms ipc audio increment 3";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = spawn "dms ipc audio decrement 3";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn = spawn "dms ipc audio mute";
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn = spawn "dms ipc audio micmute";
        };
        "Mod+Alt+N" = {
          allow-when-locked = true;
          action.spawn = spawn "dms ipc night toggle";
          hotkey-overlay.title = hotkey {
            color = blue0;
            name = "DankMaterialShell";
            text = "Night Mode";
          };
        };
        "Mod+M" = {
          action.spawn = spawn "dms ipc processlist toggle";
          hotkey-overlay.title = hotkey {
            color = blue0;
            name = "DankMaterialShell";
            text = "Processlist";
          };
        };
        "Mod+Y" = {
          action.spawn = spawn "dms ipc clipboard toggle";
          hotkey-overlay.title = hotkey {
            color = blue0;
            name = "DankMaterialShell";
            text = "Clipboard";
          };
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn = spawn "dms ipc brightness increment 5 ";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn = spawn "dms ipc brightness decrement 5 ";
        };
      };
      layer-rules = [
        {
          matches = singleton {
            namespace = "^dms:blurwallpaper$";
          };
          place-within-backdrop = true;
        }
      ];
    };
  };
}
