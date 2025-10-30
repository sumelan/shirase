{
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit (lib) optionalString getExe;
  inherit (config.hm.lib.monitors) mainMonitor mainMonitorName;

  # Black
  black0 = "#191D24";
  black1 = "#1E222A";
  black2 = "#222630";

  # Gray
  gray0 = "#242933";
  # Polar night
  gray1 = "#2E3440";
  gray2 = "#3B4252";
  gray3 = "#434C5E";
  gray4 = "#4C566A";
  # a light blue/gray
  # from @nightfox.nvim
  gray5 = "#60728A";

  # White
  # reduce_blue variant
  white0 = "#C0C8D8";
  # Snow storm
  white1 = "#D8DEE9";
  white2 = "#E5E9F0";
  white3 = "#ECEFF4";

  # Blue
  # Frost
  blue0 = "#5E81AC";
  blue1 = "#81A1C1";
  blue2 = "#88C0D0";

  # Cyan:
  cyan_base = "#8FBCBB";
  cyan_bright = "#9FC6C5";
  cyan_dim = "#80B3B2";

  # Aurora (from Nord theme)
  # Red
  red_base = "#BF616A";
  red_bright = "#C5727A";
  red_dim = "#B74E58";

  # Orange
  orange_base = "#D08770";
  orange_bright = "#D79784";
  orange_dim = "#CB775D";

  # Yellow
  yellow_base = "#EBCB8B";
  yellow_bright = "#EFD49F";
  yellow_dim = "#E7C173";

  # Green
  green_base = "#A3BE8C";
  green_bright = "#B1C89D";
  green_dim = "#97B67C";

  # Magenta
  magenta_base = "#B48EAD";
  magenta_bright = "#BE9DB8";
  magenta_dim = "#A97EA1";
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
