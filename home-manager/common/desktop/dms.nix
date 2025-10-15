{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    getExe
    getExe'
    ;

  inherit
    (config.lib.stylix.colors.withHashtag)
    base0A
    ;
  inherit (config.lib.niri.actions) spawn;
in {
  options.custom = {
    dms.enable = mkEnableOption "DankMaterialShell" // {default = true;};
  };

  config = mkIf config.custom.dms.enable {
    programs = {
      dankMaterialShell = {
        enable = true;
      };

      niri.settings = {
        spawn-at-startup = [
          # clipboard manager
          {sh = "${getExe' pkgs.wl-clipboard "wl-paste"} --watch ${getExe pkgs.cliphist} store &";}
          {argv = ["dms" "run"];}
        ];
        binds = let
          dms-ipc = spawn "dms" "ipc";
          hotkeyColor = base0A;
        in {
          "Mod+Space" = {
            action = dms-ipc "spotlight" "toggle";
            hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[DMS]</span> Application Launcher'';
          };
          "Mod+N" = {
            action = dms-ipc "notifications" "toggle";
            hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[DMS]</span> Notification Center'';
          };
          "Mod+Comma" = {
            action = dms-ipc "settings toggle";
            hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[DMS]</span> Settings'';
          };
          "Mod+P" = {
            action = dms-ipc "notepad" "toggle";
            hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[DMS]</span> Notepad'';
          };
          "Mod+Alt+L" = {
            allow-when-locked = true;
            action = dms-ipc "lock" "lock";
            hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[DMS]</span> Lock Screen'';
          };
          "Mod+X" = {
            action = dms-ipc "powermenu" "toggle";
            hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[DMS]</span> Power Menu'';
          };
          "Mod+M" = {
            action = dms-ipc "processlist" "toggle";
            hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[DMS]</span> Process List'';
          };
          "Mod+V" = {
            action = dms-ipc "clipboard" "toggle";
            hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[DMS]</span> Clipboard Manager'';
          };
          "Mod+Alt+N" = {
            allow-when-locked = true;
            action = dms-ipc "night" "toggle";
            hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[DMS]</span> Toggle Night Mode'';
          };
          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action = dms-ipc "brightness" "increment" "5" "";
          };
          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action = dms-ipc "brightness" "decrement" "5" "";
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
        };
      };
    };

    custom.persist = {
      home.directories = [
        ".config/DankMaterialShell"
      ];
    };
  };
}
