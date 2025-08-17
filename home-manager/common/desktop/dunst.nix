{
  lib,
  config,
  pkgs,
  ...
}: {
  options.custom = {
    dunst.enable =
      lib.mkEnableOption "Dunst"
      // {
        default = true;
      };
  };

  config = lib.mkIf config.custom.dunst.enable {
    home.packages = with pkgs; [libnotify];
    services.dunst = {
      enable = true;
      settings = with config.lib.stylix.colors.withHashtag; let
        inherit (config.stylix) fonts;
        dunstOpacity =
          ((builtins.floor (config.stylix.opacity.popups * 100 + 0.5)) * 255) / 100 |> lib.toHexString;
      in {
        global = {
          origin = "top-right";
          separator_color = base02;
          font = "${fonts.sansSerif.name} ${toString fonts.sizes.popups}";
          icon_theme = config.gtk.iconTheme.name;
          width = "(250, 400)";
          offset = "(30, 30)";
          alignment = "center";
          browser = "librewolf -new-tab";
          corner_radius = 8;
          dmenu = "fuzzel -d dunst";
          enable_recursive_icon_lookup = true;
          ellipsize = "end";
          follow = "mouse";
          frame_width = 2;
          max_icon_size = 72;
          mouse_left_click = "do_action";
          mouse_middle_click = "do_action";
          mouse_right_click = "close_current";
          separator_height = 1;
          show_indicators = "no";
        };
        urgency_normal = {
          background = base01 + dunstOpacity;
          foreground = base05;
          frame_color = base0B;
          timeout = 6;
        };
        urgency_critical = {
          background = base01 + dunstOpacity;
          foreground = base05;
          frame_color = base08;
          timeout = 0;
        };
        urgency_low = {
          background = base01 + dunstOpacity;
          foreground = base05;
          frame_color = base03;
          timeout = 4;
        };
      };
    };

    programs.niri.settings = {
      binds = {
        "Mod+Shift+N" = lib.custom.niri.runCmd {
          cmd = "dunstctl history-pop";
          title = "Notification history";
        };
        "Mod+Alt+N" = lib.custom.niri.runCmd {
          cmd = "dunstctl close-all";
          title = "Dismiss notification";
        };
      };
      layer-rules = [
        {
          matches = lib.singleton {
            namespace = "^(notifications)";
          };
          block-out-from = "screen-capture";
        }
      ];
    };
    stylix.targets.dunst.enable = false;
  };
}
