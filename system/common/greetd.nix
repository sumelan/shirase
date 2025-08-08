{
  lib,
  config,
  pkgs,
  user,
  ...
}: {
  # tty autologin
  services.getty.autologinUser = user;

  # for mango
  # set fallback config in /etc/mango/config.conf and write autostart.sh
  # environment.etc =
  #   let
  #     monitorRules = "monitorrule=${config.hm.lib.monitors.mainMonitorName},0,1,tile,0,1.0,0,0";
  #   in
  #   {
  #     "mango/config.conf".text = ''
  #       tap_to_click=1
  #       trackpad_natural_scrolling=1

  #       cursor_theme=${config.hm.stylix.cursor.name}
  #       cursor_size=${config.hm.stylix.cursor.size |> builtins.toString}

  #       ${monitorRules}

  #       env=XCURSOR_SIZE,${config.hm.stylix.cursor.size |> builtins.toString}
  #       env=GTK_USE_PORTAL,0
  #       env=GDK_DEBUG,no-portals
  #     '';
  #   };

  # backlightCmd = lib.optionalString config.hm.custom.backlight.enable ''
  #   ${lib.getExe pkgs.brightnessctl} set 5%
  # '';
  # autostart.sh =
  #   pkgs.writeShellScript "autostart.sh"
  # bash
  #     ''
  #       ${backlightCmd}
  #       ${lib.getExe pkgs.greetd.regreet}; pkill -f mango
  #     '';
  #
  services.greetd = {
    enable = true;
    settings = {
      default_session = let
        inherit (config.hm.lib.monitors) mainMonitor;
        mainScale = mainMonitor.scale |> builtins.toString;
        mainMode = "${mainMonitor.mode.width |> builtins.toString}x${
          mainMonitor.mode.height |> builtins.toString
        }@${mainMonitor.mode.refresh |> builtins.toString}";

        backlightSpawn = lib.optionalString config.hm.custom.backlight.enable ''
          spawn-at-startup "sh" "-c" "${lib.getExe pkgs.brightnessctl} set 5%"
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
                xcursor-theme "${config.hm.stylix.cursor.name}"
                xcursor-size ${config.hm.stylix.cursor.size |> builtins.toString}
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
            spawn-at-startup "sh" "-c" "${lib.getExe pkgs.greetd.regreet}; pkill -f niri"
          '';
      in {
        command = "niri -c ${niri-config}";
        # command = "mango -s ${autostart.sh}";
        user = "greeter";
      };
    };
  };

  # theme, iconTheme, cursorTheme, font are installed via system-wide
  programs.regreet = {
    enable = true;
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
      inherit (config.hm.stylix.cursor) package name;
    };
    settings = {
      background = {
        path = ../../hosts/regreet.png;
        fit = "Contain";
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
            filter: blur(.2rem);
          }

          frame.background {
            background: alpha(${base01}, .92);
            color: ${base05};
            border-radius: 24px;
            box-shadow: 0 0 8px 0 alpha(${base02}, .92);
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
            color: ${base03};
            padding: 12px;
            margin: 0 8px;
            border-radius: 12px;
            transition: background .3s ease-in-out;
          }

          box.horizontal>button.default.suggested-action.text-button:hover {
            background: shade(${base0B}, 1.2);
          }

          box.horizontal>button.text-button {
            background: ${base01};
            color: ${base06};
            padding: 12px;
            border-radius: 12px;
            transition: background .3s ease-in-out;
          }

          box.horizontal>button.text-button:hover {
            background: shade(${base01}, 1.2);
            color: ${base08};
          }

          combobox {
            background: ${base02};
            color: ${base05};
            border-radius: 12px;
            padding: 12px;
            box-shadow: 0 0 4px 0 alpha(${base02}, .6);
          }

          combobox:disabled {
            background: ${base00};
            color: alpha(${base04}, .6);
            border-radius: 12px;
            padding: 12px;
            box-shadow: 0 0 4px 0 alpha(${base02}, .6);
          }

          modelbutton.flat {
            background: ${base03};
            color: ${base07};
            padding: 6px;
            margin: 2px;
            border-radius: 8px;
            border-spacing: 6px;
          }

          modelbutton.flat:hover {
            background: shade(${base03}, 1.2);
            color: ${base07};
          }

          button.image-button.toggle {
            margin-right: 36px;
            padding: 12px;
            border-radius: 12px;
          }

          button.image-button.toggle:hover {
            background: ${base01};
            box-shadow: 0 0 4px 0px alpha(${base02}, .6);
          }

          button.image-button.toggle:disabled {
            background: ${base00};
            color: alpha(${base04}, .6);
            margin-right: 36px;
            padding: 12px;
            border-radius: 12px;
          }

          combobox>popover {
            background: ${base02};
            color: ${base04};
            border-radius: 8px;
            border-spacing: 6px;
            box-shadow: 0 0 4px 0 alpha(${base02}, .6);
            padding: 6px 12px;
          }

          combobox>popover>contents {
            padding: 2px;
          }

          combobox:hover {
            background: shade(${base02}, 1.2);
          }

          entry.password {
            border: 2px solid ${base0D};
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
