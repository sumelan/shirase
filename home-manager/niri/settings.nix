{
  lib,
  config,
  ...
}:
let
  inherit (config.custom) outputs;
  makeCommand = command: {
    command = [command];
  };
in 
{
  options.custom = with lib; {
    niri = {
      enable = mkEnableOption "Niri";
      outputs = mkOption {
        type = 
          with types;
          nonEmptyListOf (
          submodule (
            { config, ... }:
            {
              options = {
                name = mkOption {
                  type = str;
                  description = "The name of the display, e.g. eDP-1";
                };
                width = mkOption {
                  type = int;
                  description = "Pixel width of the display";
                };
                height = mkOption {
                  type = int;
                  description = "Pixel width of the display";
                };
                refreshRate = mkOption {
                  type = int;
                  default = 60;
                  description = "Refresh rate of the display";
                };
                position = {
                  x = mkOption {
                    type = int;
                    default = 0;
                    description = "Position of x-axis on the display";
                  };
                  y = mkOption {
                    type = int;
                    default = 0;
                    description = "Position of y-axis on the display";
                  };
                };
                scale = mkOption {
                  type = float;
                  default = 1.0;
                };
                vrr = mkEnableOption "Variable Refresh Rate";
                transform.rotation = mkOption {
                  type = oneOf [ 0 90 180 270 ];
                  description = "Is the display vertical?";
                  default = 0;
                };
              };
            }
          )
        );
      default = [ ];
      description = "Config for monitors";
    };
  };

  config = lib.mkIf config.custom.niri.enable {
    programs.niri = {
      enable = true;
      settings = {
        environment = {
          CLUTTER_BACKEND = "wayland";
          DISPLAY = ":0";
          GDK_BACKEND = "wayland,x11";
          MOZ_ENABLE_WAYLAND = "1";
          NIXOS_OZONE_WL = "1";
          QT_QPA_PLATFORM = "wayland;xcb";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          SDL_VIDEODRIVER = "wayland";
        };
        spawn-at-startup = [
          (makeCommand "uwsm finalize")
          (makeCommand "uwsm app -- nm-applet")
          (makeCommand "uwsm app -- blueman-applet")
          (makeCommand "uwsm app -- fcitx5")
          (makeCommand "swww-daemon")
          (makeCommand "wl-paste --type image --watch cliphist store")
          (makeCommand "wl-paste --type text --watch cliphist store")
          (makeCommand "uwsm app -- hyprlock")
        ];
        input = {
          keyboard.xkb.layout = "us";
          touchpad = {
            click-method = "button-areas";
            dwt = true;
            dwtp = true;
            natural-scroll = true;
            scroll-method = "two-finger";
            tap = true;
            tap-button-map = "left-right-middle";
            accel-profile = "adaptive";
            # scroll-factor = 0.1;
          };
          focus-follows-mouse.enable = true;
          warp-mouse-to-focus = true;
          workspace-auto-back-and-forth = true;
        };

        inherit outputs;

        layout = {
          focus-ring.enable = false;
          border = {
            enable = true;
            width = 1;
            active.color = "#16aff1";
            inactive.color = "#245b89";
          };

          preset-column-widths = [
            {proportion = 1.0 / 3.0;}
            {proportion = 1.0 / 2.0;}
            {proportion = 2.0 / 3.0;}
            {proportion = 1.0;}
          ];
          default-column-width = {proportion = 1.0 / 2.0;};

          gaps = 8;
          struts = {
            left = 0;
            right = 0;
            top = 0;
            bottom = 0;
          };
        };

        animations.shaders.window-resize = ''
          vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
            vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;

            vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
            vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;

            // We can crop if the current window size is smaller than the next window
            // size. One way to tell is by comparing to 1.0 the X and Y scaling
            // coefficients in the current-to-next transformation matrix.
            bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
            bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;

            vec3 coords = coords_stretch;
            if (can_crop_by_x)
                coords.x = coords_crop.x;
            if (can_crop_by_y)
                coords.y = coords_crop.y;

            vec4 color = texture2D(niri_tex_next, coords.st);

            // However, when we crop, we also want to crop out anything outside the
            // current geometry. This is because the area of the shader is unspecified
            // and usually bigger than the current geometry, so if we don't fill pixels
            // outside with transparency, the texture will leak out.
            //
            // When stretching, this is not an issue because the area outside will
            // correspond to client-side decoration shadows, which are already supposed
            // to be outside.
            if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
                color = vec4(0.0);
            if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
                color = vec4(0.0);

            return color;
          }
        '';
        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;
        };
      };
    };
  };
}
