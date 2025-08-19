{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [inputs.noctalia-shell.homeModules.noctalia-shell];

  options.custom = {
    noctalia-shell.enable = lib.mkEnableOption "Noctalia for Niri";
  };

  config = lib.mkIf config.custom.noctalia-shell.enable {
    programs.noctalia-shell = {
      enable = true;
      enableSystemd = true;
      enableSpawn = false;
    };

    programs.niri.settings.binds = {
      "Mod+D" = {
        action.spawn = ["qs" "-c" "noctalia-shell" "ipc" "call" "appLauncher" "toggle"];
        hotkey-overlay.title = "Toggle launcher";
      };
      "Mod+N" = {
        action.spawn = ["qs" "-c" "noctalia-shell" "ipc" "call" "notifications" "toggleHistory"];
        hotkey-overlay.title = "Toggle Notification History";
      };
      "Mod+Comma" = {
        action.spawn = ["qs" "-c" "noctalia-shell" "ipc" "call" "settings" "toggle"];
        hotkey-overlay.title = "Toggle Settings Panel";
      };
      "Mod+Ctrl+L" = {
        action.spawn = ["qs" "-c" "noctalia-shell" "ipc" "call" "lockScreen" "toggle"];
        hotkey-overlay.title = "Toggle lock screen";
      };
      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = [];
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = [];
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = [];
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn = [];
      };
      "XF86AudioPlay" = {
        allow-when-locked = true;
        action.spawn = [];
      };
      "XF86AudioPause" = {
        allow-when-locked = true;
        action.spawn = [];
      };
      "XF86AudioNext" = {
        allow-when-locked = true;
        action.spawn = [];
      };
      "XF86AudioPrev" = {
        allow-when-locked = true;
        action.spawn = [];
      };
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = ["qs" "-c" "noctalia-shell" "ipc" "call" "brightness" "increase"];
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = ["qs" "-c" "noctalia-shell" "ipc" "call" "brightness" "decrease"];
      };
    };

    custom.persist = {
      home.directories = [
        ".config/noctalia"
      ];
    };
  };
}
