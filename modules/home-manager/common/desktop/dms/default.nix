{lib, ...}: let
  inherit (lib) singleton splitString;
  inherit (lib.custom.colors) magenta_dim;
  inherit (lib.custom.niri) hotkey;
in {
  imports = [
    ./plugins.nix
    ./settings.nix
  ];

  programs = {
    dankMaterialShell = {
      enable = true;
      systemd = {
        enable = false;
        restartIfChanged = false;
      };
    };

    niri.settings = {
      binds = let
        dms-ipc = cmd:
          ["dms" "ipc" "call"] ++ (splitString " " cmd);
      in {
        "Mod+Space" = {
          action.spawn = dms-ipc "spotlight toggle";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Launcher";
          };
        };
        "Mod+D" = {
          action.spawn = dms-ipc "dash toggle overview";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Dashboard";
          };
        };
        "Mod+W" = {
          action.spawn = dms-ipc "dankdash wallpaper";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Wallpapers";
          };
        };
        "Mod+N" = {
          action.spawn = dms-ipc "notifications toggle";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Notifications";
          };
        };
        "Mod+Comma" = {
          action.spawn = dms-ipc "settings toggle";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Settings";
          };
        };
        "Mod+P" = {
          action.spawn = dms-ipc "notepad toggle";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Notepad";
          };
        };
        "Mod+Alt+L" = {
          action.spawn = dms-ipc "lock lock";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Lock Screen";
          };
        };
        "Mod+X" = {
          action.spawn = dms-ipc "powermenu toggle";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Power Menu";
          };
        };
        "Mod+I" = {
          action.spawn = dms-ipc "inhibit toggle";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Idle Inhibitor";
          };
        };
        "Mod+Alt+N" = {
          action.spawn = dms-ipc "night toggle";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Night Mode";
          };
        };
        "Mod+M" = {
          action.spawn = dms-ipc "processlist toggle";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Processlist";
          };
        };
        "Mod+Y" = {
          action.spawn = dms-ipc "clipboard toggle";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Clipboard";
          };
        };
        "Mod+Backslash" = {
          action.spawn = dms-ipc "niri screenshot";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Interactive Screen-capture";
          };
        };
        "Mod+Shift+Backslash" = {
          action.spawn = dms-ipc "niri screenshotScreen";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Capture entire screen";
          };
        };
        "Mod+Alt+Backslash" = {
          action.spawn = dms-ipc "niri screenshotWindow";
          hotkey-overlay.title = hotkey {
            color = magenta_dim;
            name = "󰮤  DankMaterialShell";
            text = "Capture focused window";
          };
        };
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "audio increment 3";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "audio decrement 3";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "audio mute";
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "audio micmute";
        };
        "XF86AudioPlay" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "mpris playPause";
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "mpris next";
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "mpris previous";
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "brightness increment 5 ";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "brightness decrement 5 ";
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

      environment = {
        DMS_SCREENSHOT_EDITOR = "satty";
      };
    };
  };

  custom.persist = {
    home = {
      directories = [
        ".local/state/DankMaterialShell"
      ];
      cache.directories = [
        ".cache/DankMaterialShell"
      ];
    };
  };
}
