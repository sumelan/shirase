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
    home.packages =
      (with inputs; [
        noctalia.packages.${pkgs.system}.default
        quickshell.packages.${pkgs.system}.default
      ])
      ++ [pkgs.wlsunset];

    programs.niri.settings = {
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
        hotkeyColor = config.lib.stylix.colors.withHashtag.base0D;
      in {
        "Mod+Space" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "launcher" "toggle"];
          hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Launcher'';
        };
        "Mod+V" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "launcher" "clipboard"];
          hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Clipboard'';
        };
        "Mod+N" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "notifications" "toggleHistory"];
          hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Notification Histories'';
        };
        "Mod+D" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "sidePanel" "toggle"];
          hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Sidepanel'';
        };
        "Mod+Comma" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "settings" "toggle"];
          hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Settings'';
        };
        "Mod+Alt+L" = {
          allow-when-locked = true;
          action.spawn = ["noctalia-shell" "ipc" "call" "lockScreen" "toggle"];
          hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Lock Screen'';
        };
        "Mod+I" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "idleInhibitor" "toggle"];
          hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Toggle Idleinhibitor'';
        };
        "Mod+X" = {
          action.spawn = ["noctalia-shell" "ipc" "call" "powerPanel" "toggle"];
          hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Powerpanel'';
        };
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = ["noctalia-shell" "ipc" "call" "volume" "increase"];
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = ["noctalia-shell" "ipc" "call" "volume" "decrease"];
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn = ["noctalia-shell" "ipc" "call" "volume" "muteOutput"];
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn = ["noctalia-shell" "ipc" "call" "volume" "muteInput"];
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
      spawn-at-startup = [
        {argv = ["noctalia-shell"];}
      ];
    };

    custom.persist = {
      home.directories = [
        ".config/noctalia"
      ];
    };
  };
}
