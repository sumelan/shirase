{
  lib,
  config,
  pkgs,
  user,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkForce
    ;
in {
  imports = [inputs.niri-caelestia.homeManagerModules.default];

  options.custom = {
    niri-caelestia.enable = mkEnableOption "A very segsy desktop shell ported to niri wm";
  };

  config = mkIf config.custom.niri-caelestia.enable {
    programs.caelestia = {
      enable = true;
      package = inputs.niri-caelestia.packages.${pkgs.system}.default;
      systemd = {
        enable = true;
        inherit (config.wayland.systemd) target;
        environment = [
          "QT_QPA_PLATFORMTHEME=gtk3"
        ];
      };
      settings = {
        general = {
          apps = {
            terminal = [config.profiles.${user}.defaultTerminal.name];
            audio = ["pwvucontrol"];
          };
        };
        background = {
          enabled = true;
          desktopClock = {
            enabled = true;
          };
          visualiser = {
            enabled = true;
            autoHide = true;
            rounding = 1;
            spacing = 1;
          };
        };
        bar = {
          entries = [
            {
              id = "logo";
              enabled = true;
            }
            {
              id = "spacer";
              enabled = true;
            }
            {
              id = "workspaces";
              enabled = true;
            }
            {
              id = "spacer";
              enabled = true;
            }
            {
              id = "clock";
              enabled = true;
            }
            {
              id = "statusIcons";
              enabled = true;
            }
            {
              id = "idleInhibitor";
              enabled = true;
            }
            {
              id = "power";
              enabled = true;
            }
          ];
          workspaces = {
            activeLabel = "󰗢";
            occupiedLabel = "⊙";
          };
        };
        launcher = {
          vimKeybinds = true;
        };
        paths = {
          wallpaperDir = "~/Pictures/Wallpapers";
        };
        services = {
          defaultPlayer = "Euphonica";
          playerAliases = [
            {
              from = "io.github.htkhiem.Euphonica";
              to = "Euphonica";
            }
          ];
        };
        session = {
          vimKeybinds = true;
          commands = {
            logout = ["loginctl" "terminate-user" ""];
            shutdown = ["systemctl" "poweroff"];
            hibernate = ["systemctl" "suspend"];
            reboot = ["systemctl" "reboot"];
          };
        };
        appearance = {
          font = {
            familiy = {
              material = config.stylix.fonts.sansSerif.name;
              mono = config.stylix.fonts.monospace.name;
              sans = config.stylix.fonts.sansSerif.name;
            };
            size = {
              scale = 1;
            };
          };
          transparency = {
            enabled = true;
            base = config.stylix.opacity.desktop;
            layers = config.stylix.opacity.popups;
          };
        };
      };

      extraConfig = "";
      cli.enable = mkForce false;
    };

    programs.niri.settings = {
      binds = {
        "Mod+Space" = {
          action.spawn = ["caelestia-shell" "ipc" "call" "drawers" "toggle" "launcher"];
          hotkey-overlay.title = "[QuickShell] Launcher";
        };
        "Mod+Q" = {
          action.spawn = ["caelestia-shell" "ipc" "call" "drawers" "toggle" "session"];
          hotkey-overlay.title = "[QuickShell] Session";
        };
        "Mod+Ctrl+L" = {
          action.spawn = ["caelestia-shell" "ipc" "call" "lock" "lock"];
          hotkey-overlay.title = "[QuickShell] Lock";
          allow-when-locked = true;
        };
        "XF86AudioPlay" = {
          action.spawn = ["caelestia-shell" "ipc" "call" "mpris" "playPause"];
          allow-when-locked = true;
        };
        "XF86AudioPause" = {
          action.spawn = ["caelestia-shell" "ipc" "call" "mpris" "playPause"];
          allow-when-locked = true;
        };
        "XF86AudioNext" = {
          action.spawn = ["caelestia-shell" "ipc" "call" "mpris" "next"];
          allow-when-locked = true;
        };
        "XF86AudioPrev" = {
          action.spawn = ["caelestia-shell" "ipc" "call" "mpris" "previous"];
          allow-when-locked = true;
        };
      };
    };
  };
}
