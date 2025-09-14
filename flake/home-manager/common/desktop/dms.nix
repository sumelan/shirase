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
    getExe
    singleton
    ;
in {
  imports = [inputs.dms.homeModules.dankMaterialShell];

  options.custom = {
    dms.enable = mkEnableOption "Dank Material Shell for Niri";
  };

  config = mkIf config.custom.dms.enable {
    programs = {
      dankMaterialShell.enable = true;

      niri.settings = {
        binds = with config.lib.niri.actions; let
          dms-ipc = spawn "dms" "ipc";
          hotkeyColor = config.lib.stylix.colors.withHashtag.base07;
        in {
          "Mod+Space" = {
            action = dms-ipc "spotlight" "toggle";
            hotkey-overlay.title = "<span foreground='${hotkeyColor}'>[DankMaterialShell]</span> Application Launcher";
          };
          "Mod+D" = {
            action = dms-ipc "dash" "open" "overview";
            hotkey-overlay.title = "<span foreground='${hotkeyColor}'>[DankMaterialShell]</span> Dashboard";
          };
          "Mod+N" = {
            action = dms-ipc "notifications" "toggle";
            hotkey-overlay.title = "<span foreground='${hotkeyColor}'>[DankMaterialShell]</span> Notification Center";
          };
          "Mod+Comma" = {
            action = dms-ipc "settings" "toggle";
            hotkey-overlay.title = "<span foreground='${hotkeyColor}'>[DankMaterialShell]</span> Settings";
          };
          "Mod+P" = {
            action = dms-ipc "notepad" "toggle";
            hotkey-overlay.title = "<span foreground='${hotkeyColor}'>[DankMaterialShell]</span> Notepad";
          };
          "Super+Alt+L" = {
            action = dms-ipc "lock" "lock";
            hotkey-overlay.title = "<span foreground='${hotkeyColor}'>[DankMaterialShell]</span> Screen Lock";
          };
          "Mod+X" = {
            action = dms-ipc "powermenu" "toggle";
            hotkey-overlay.title = "<span foreground='${hotkeyColor}'>[DankMaterialShell]</span> Power Menu";
          };
          "Mod+M" = {
            action = dms-ipc "processlist" "toggle";
            hotkey-overlay.title = "<span foreground='${hotkeyColor}'>[DankMaterialShell]</span> Processlist";
          };
          "Mod+V" = {
            action = dms-ipc "clipboard" "toggle";
            hotkey-overlay.title = "<span foreground='${hotkeyColor}'>[DankMaterialShell]</span> Clipboard Manager";
          };
          "Mod+Alt+N" = {
            allow-when-locked = true;
            action = dms-ipc "night" "toggle";
            hotkey-overlay.title = "<span foreground='${hotkeyColor}'>[DankMaterialShell]</span> Toggle Night Mode";
          };
          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action = dms-ipc "audio" "increment" "3";
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action = dms-ipc "audio" "decrement" "3";
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action = dms-ipc "audio" "mute";
          };
          "XF86AudioMicMute" = {
            allow-when-locked = true;
            action = dms-ipc "audio" "micmute";
          };
          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action = dms-ipc "brightness" "increment" "5" "";
          };
          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action = dms-ipc "brightness" "decrement" "5" "";
          };
        };
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

    systemd.user.services = {
      "dms" = {
        Unit = {
          Description = "Dank Material Shell Service";
          After = [config.wayland.systemd.target];
          PartOf = [config.wayland.systemd.target];
        };
        Service = {
          Type = "exec";
          ExecStart = "${getExe config.programs.quickshell.package} -c dms";
          Restart = "on-failure";
          RestartSec = "5s";
          TimeoutStopSec = "5s";
          Environment = [
            "QT_QPA_PLATFORM=wayland"
            "ELECTRON_OZONE_PLATFORM_HINT=auto"
          ];
          Slice = "session.slice";
        };
        Install = {
          WantedBy = [config.wayland.systemd.target];
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
