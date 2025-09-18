{
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit
    (lib)
    optionalString
    getExe
    ;
in {
  # tty autologin
  services.getty.autologinUser = user;

  services.greetd = {
    enable = true;
    settings = {
      default_session = let
        inherit (config.hm.lib.monitors) mainMonitor;
        mainScale = builtins.toString mainMonitor.scale;
        mainMode = "${builtins.toString mainMonitor.mode.width}x${
          builtins.toString mainMonitor.mode.height
        }@${builtins.toString mainMonitor.mode.refresh}";

        backlightSpawn = optionalString config.hm.custom.backlight.enable ''
          spawn-sh-at-startup "${getExe pkgs.brightnessctl} set 5%"
        '';

        niri-config =
          pkgs.writeText "niri-config"
          # kdl
          ''
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

            output "${config.hm.lib.monitors.mainMonitorName}" {
                scale ${mainScale}
                transform "normal"
                position x=0 y=0
                mode "${mainMode}"
            }

            ${backlightSpawn}
            spawn-sh-at-startup "${getExe pkgs.regreet}; pkill -f niri"
          '';
      in {
        command = "niri -c ${niri-config}";
        user = "greeter";
      };
    };
  };

  # theme, iconTheme, cursorTheme, font are installed via system-wide
  programs.regreet = {
    enable = true;
    package = pkgs.regreet;
    theme = {
      inherit (config.hm.gtk.theme) package name;
    };
    iconTheme = {
      inherit (config.hm.gtk.iconTheme) package name;
    };
    font = {
      inherit (config.hm.stylix.fonts.monospace) package name;
      size = config.hm.stylix.fonts.sizes.desktop;
    };
    cursorTheme = {
      inherit (config.hm.home.pointerCursor) package name;
    };
    settings = {
      background = {
        path = ./regreet.png;
        fit = "Cover";
      };
      GTK.application_prefer_dark_theme = true;
      appearance.greeting_msg = "Welcome back!";
      widget.clock = {
        format = "%a %H:%M";
        resolution = "500ms";
        label_width = 450; # the interpretation of this value is entirely up to GTK
      };
    };
    extraCss = with config.lib.stylix.colors.withHashtag;
    # css
      ''
        * {
            all: unset;
          }

          picture {
            filter: blur(0rem);
          }

          frame.background {
            background: alpha(${base01}, .92);
            color: ${base05};
            border-radius: 24px;
            box-shadow: 0 0 8px 0 alpha(${base00}, .92);
          }

          frame.background.top {
            font-size: 1.2rem;
            padding: 8px;
            background: ${base01};
            border-radius: 0;
            border-bottom-left-radius: 24px;
            border-bottom-right-radius: 24px;
          }

          box.horizontal>button.default.suggested-action.text-button {
            background: ${base0B};
            color: ${base02};
            padding: 12px;
            margin: 0 8px;
            border-radius: 12px;
            transition: background .3s ease-in-out;
          }

          box.horizontal>button.default.suggested-action.text-button:hover {
            background: shade(${base0C}, 1.2);
            color: ${base00};
          }

          box.horizontal>button.text-button {
            background: ${base0E};
            color: ${base02};
            padding: 12px;
            border-radius: 12px;
            transition: background .3s ease-in-out;
          }

          box.horizontal>button.text-button:hover {
            background: shade(${base06}, 1.2);
            color: ${base00};
          }

          combobox {
            background: ${base01};
            color: ${base05};
            border-radius: 12px;
            padding: 12px;
            box-shadow: 0 0 4px 0 alpha(${base00}, .6);
          }

          combobox:disabled {
            background: ${base01};
            color: alpha(${base08}, .6);
            border-radius: 12px;
            padding: 12px;
            box-shadow: 0 0 4px 0 alpha(${base00}, .6);
          }

          modelbutton.flat {
            background: ${base02};
            color: ${base0D};
            padding: 6px;
            margin: 2px;
            border-radius: 8px;
            border-spacing: 6px;
          }

          modelbutton.flat:hover {
            background: shade(${base03}, 1.2);
            color: ${base0C};
          }

          button.image-button.toggle {
            margin-right: 36px;
            padding: 12px;
            border-radius: 12px;
          }

          button.image-button.toggle:hover {
            background: ${base02};
            box-shadow: 0 0 4px 0px alpha(${base00}, .6);
          }

          button.image-button.toggle:disabled {
            background: ${base02};
            color: alpha(${base06}, .6);
            margin-right: 36px;
            padding: 12px;
            border-radius: 12px;
          }

          combobox>popover {
            background: ${base02};
            color: ${base04};
            border-radius: 8px;
            border-spacing: 6px;
            box-shadow: 0 0 4px 0 alpha(${base00}, .6);
            padding: 6px 12px;
          }

          combobox>popover>contents {
            padding: 2px;
          }

          combobox:hover {
            background: shade(${base02}, 1.2);
          }

          entry.password {
            border: 2px solid ${base0C};
            border-radius: 12px;
            padding: 12px;
          }

          entry.password:hover {
            border: 2px solid ${base0D};
          }
      '';
  };
  custom.persist = {
    root.directories = [
      # last authenticated user and the last used session per user
      "/var/lib/regreet"
    ];
  };
  stylix.targets.regreet.enable = false;
}
