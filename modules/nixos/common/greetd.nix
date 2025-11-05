{
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit (lib) optionalString getExe;
  inherit (config.hm.lib.monitors) mainMonitor mainMonitorName;
  inherit
    (lib.custom.colors)
    black0
    black2
    gray0
    gray3
    gray4
    gray5
    white0
    white3
    blue0
    blue2
    yellow_base
    red_bright
    green_dim
    green_bright
    orange_dim
    orange_bright
    magenta_dim
    magenta_bright
    ;
in {
  # tty autologin
  services.getty.autologinUser = user;

  services.greetd = {
    enable = true;
    settings = {
      default_session = let
        mainMode = "${builtins.toString mainMonitor.mode.width}x${
          builtins.toString mainMonitor.mode.height
        }@${builtins.toString mainMonitor.mode.refresh}";
        mainScale = builtins.toString mainMonitor.scale;
        mainRotate =
          if mainMonitor.rotation == 0
          then "normal"
          else builtins.toString mainMonitor.rotation;

        initialBacklight = optionalString config.hm.custom.backlight.enable ''
          spawn-sh-at-startup "${pkgs.brightnessctl}/bin/brightnessctl set 5%"
        '';

        niri-config =
          pkgs.writeText "niri-config"
          # kdl
          ''
            spawn-sh-at-startup "${pkgs.regreet}/bin/regreet; niri msg action quit --skip-confirmation"

            hotkey-overlay {
                skip-at-startup
            }

            environment {
                GTK_USE_PORTAL "0"
                GDK_DEBUG "no-portals"
            }

            cursor {
                xcursor-theme "${config.hm.home.pointerCursor.name}"
                xcursor-size ${builtins.toString config.hm.home.pointerCursor.size}
            }

            input {
                touchpad {
                    tap
                    natural-scroll
                }
            }

            output "${mainMonitorName}" {
                scale ${mainScale}
                transform "${mainRotate}"
                position x=0 y=0
                mode "${mainMode}"
            }

            ${initialBacklight}
          '';
      in {
        command = "${getExe config.programs.niri.package} -c ${niri-config}";
        user = "greeter";
      };
    };
  };

  programs.regreet = {
    enable = true;
    theme = {
      inherit (config.hm.gtk.theme) package name;
    };
    iconTheme = {
      inherit (config.hm.gtk.iconTheme) package name;
    };
    font = {
      inherit (config.hm.gtk.font) package name size;
    };
    cursorTheme = {
      inherit (config.hm.home.pointerCursor) package name;
    };
    settings = {
      background = {
        path = ./nix-nord-aurora.png;
        # Available values: "Fill", "Contain", "Cover", "ScaleDown"
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
        cursor_blink = true;
      };
      commands = {
        reboot = ["systemctl" "reboot"];
        poweroff = ["systemctl" "poweroff"];
      };
      appearance.greeting_msg = "Welcome back!";
      widget.clock = {
        format = "%a %H:%M";
        resolution = "500ms";
        # the interpretation of this value is entirely up to GTK
        label_width = 450;
      };
    };
    extraCss =
      # css
      ''
        * {
            all: unset;
          }

          picture {
            filter: blur(0.2rem);
          }

          frame.background {
            background: alpha(${gray0}, .92);
            color: ${white3};
            border-radius: 24px;
            box-shadow: 0 0 8px 0 alpha(${black0}, .92);
          }

          frame.background.top {
            font-size: 1.2rem;
            padding: 8px;
            background: ${gray3};
            border-radius: 0;
            border-bottom-left-radius: 24px;
            border-bottom-right-radius: 24px;
          }

          box.horizontal>button.default.suggested-action.text-button {
            background: ${magenta_dim};
            color: ${gray4};
            padding: 12px;
            margin: 0 8px;
            border-radius: 12px;
            transition: background .3s ease-in-out;
          }

          box.horizontal>button.default.suggested-action.text-button:hover {
            background: shade(${magenta_bright}, 1.2);
            color: ${black2};
          }

          box.horizontal>button.text-button {
            background: ${green_dim};
            color: ${gray3};
            padding: 12px;
            border-radius: 12px;
            transition: background .3s ease-in-out;
          }

          box.horizontal>button.text-button:hover {
            background: shade(${green_bright}, 1.2);
            color: ${black0};
          }

          combobox {
            background: ${gray4};
            color: ${white3};
            border-radius: 12px;
            padding: 12px;
            box-shadow: 0 0 4px 0 alpha(${black0}, .6);
          }

          combobox:disabled {
            background: ${gray4};
            color: alpha(${red_bright}, .6);
            border-radius: 12px;
            padding: 12px;
            box-shadow: 0 0 4px 0 alpha(${black0}, .6);
          }

          modelbutton.flat {
            background: ${gray4};
            color: ${blue0};
            padding: 6px;
            margin: 2px;
            border-radius: 8px;
            border-spacing: 6px;
          }

          modelbutton.flat:hover {
            background: shade(${gray5}, 1.2);
            color: ${blue2};
          }

          button.image-button.toggle {
            margin-right: 36px;
            padding: 12px;
            border-radius: 12px;
          }

          button.image-button.toggle:hover {
            background: ${gray4};
            box-shadow: 0 0 4px 0px alpha(${black0}, .6);
          }

          button.image-button.toggle:disabled {
            background: ${gray5};
            color: alpha(${yellow_base}, .6);
            margin-right: 36px;
            padding: 12px;
            border-radius: 12px;
          }

          combobox>popover {
            background: ${gray5};
            color: ${white0};
            border-radius: 8px;
            border-spacing: 6px;
            box-shadow: 0 0 4px 0 alpha(${black0}, .6);
            padding: 6px 12px;
          }

          combobox>popover>contents {
            padding: 2px;
          }

          combobox:hover {
            background: shade(${gray5}, 1.2);
          }

          entry.password {
            border: 2px solid ${orange_dim};
            border-radius: 12px;
            padding: 12px;
          }

          entry.password:hover {
            border: 2px solid ${orange_bright};
          }
      '';
  };

  custom.persist = {
    root.directories = [
      # last authenticated user and the last used session per user
      "/var/lib/regreet"
    ];
  };
}
