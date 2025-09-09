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
    singleton
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
          "ELECTRON_OZONE_PLATFORM_HINT=auto"
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
          mediaGif = ../../assets/dj-blobcat.gif;
          sessionGif = ../../assets/blob-goodnight.gif;
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
      cli.enable = mkForce false;
    };

    programs.niri.settings = {
      binds = let
        hintColor = config.lib.stylix.colors.withHashtag.base0B;
      in {
        "Mod+Space" = {
          action.spawn = ["caelestia-shell" "ipc" "call" "drawers" "toggle" "launcher"];
          hotkey-overlay.title = "<span foreground='${hintColor}'>[Niri-Caelestia]</span> Launcher";
        };
        "Mod+X" = {
          action.spawn = ["caelestia-shell" "ipc" "call" "drawers" "toggle" "session"];
          hotkey-overlay.title = "<span foreground='${hintColor}'>[Niri-Caelestia]</span> Session";
        };
        "Mod+D" = {
          action.spawn = ["caelestia-shell" "ipc" "call" "drawers" "toggle" "dashboard"];
          hotkey-overlay.title = "<span foreground='${hintColor}'>[Niri-Caelestia]</span> Dashboard";
        };
        "Mod+Alt+L" = {
          action.spawn = ["caelestia-shell" "ipc" "call" "lock" "lock"];
          hotkey-overlay.title = "<span foreground='${hintColor}'>[Niri-Caelestia]</span> Lock";
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
          matches = singleton {
            namespace = "^caelestia-background$";
          };
          place-within-backdrop = true;
        }
      ];
    };
  };
}
