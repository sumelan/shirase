{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.custom = {
    noctalia.enable = mkEnableOption "Noctalia for Niri";
  };

  config = mkIf config.custom.noctalia.enable {
    home.packages = with inputs; [
      noctalia.packages.${pkgs.system}.default
      quickshell.packages.${pkgs.system}.default
    ];

    programs.niri.settings = {
      layout = {
        background-color = "transparent";
      };
      window-rules = [
        {
          geometry-corner-radius = {
            bottom-left = 20.0;
            bottom-right = 20.0;
            top-left = 20.0;
            top-right = 20.0;
          };
          clip-to-geometry = true;
        }
      ];
      layer-rules = [
        {
          matches = [{namespace = "^swww-daemon$";}];
          place-within-backdrop = true;
        }
        {
          matches = [{namespace = "^quickshell-wallpaper$";}];
        }
        {
          matches = [{namespace = "^quickshell-overview$";}];
          place-within-backdrop = true;
        }
      ];
      binds = let
        hotkeyColor = "#c7a1d8";
      in {
        "Mod+Space" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "launcher" "toggle"];
          hotkey-overlay.title = ''<i>Toggle</i> <span foreground="${hotkeyColor}">launcher</span>'';
        };
        "Mod+V" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "launcher" "clipboard"];
          hotkey-overlay.title = ''<i>Toggle</i> <span foreground="${hotkeyColor}">Clipboard History</span>'';
        };
        "Mod+C" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "launcher" "calculator"];
          hotkey-overlay.title = ''<i>Toggle</i> <span foreground="${hotkeyColor}">Calculator</span>'';
        };
        "Mod+N" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "notifications" "toggleHistory"];
          hotkey-overlay.title = ''<i>Toggle</i> <span foreground="${hotkeyColor}">Notification History</span>'';
        };
        "Mod+S" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "sidePanel" "toggle"];
          hotkey-overlay.title = ''<i>Toggle</i> <span foreground="${hotkeyColor}">SidePanel</span>'';
        };
        "Mod+Comma" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "settings" "toggle"];
          hotkey-overlay.title = ''<i>Toggle</i> <span foreground="${hotkeyColor}">Settings Panel</span>'';
        };
        "Mod+Ctrl+L" = {
          allow-when-locked = true;
          action.spawn = ["noctalia-shell" "ipc" "call" "lockScreen" "toggle"];
          hotkey-overlay.title = ''<i>Toggle</i> <span foreground="${hotkeyColor}">Lock screen</span>'';
        };
        "Mod+I" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "idleInhibitor" "toggle"];
          hotkey-overlay.title = ''<i>Toggle</i> <span foreground="${hotkeyColor}">Idle Inhibitor</span>'';
        };
        "Mod+Q" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "powerPanel" "toggle"];
          hotkey-overlay.title = ''<i>Toggle</i> <span foreground="${hotkeyColor}">Power Panel</span>'';
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn = ["noctalia-shell" "ipc" "call" "brightness" "increase"];
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn = ["noctalia-shell" "ipc" "call" "brightness" "decrease"];
        };
      };
      spawn-at-startup = [{argv = ["noctalia-shell"];}];
    };

    services.swww.enable = true;

    custom.persist = {
      home.directories = [
        ".config/noctalia"
      ];
    };
  };
}
