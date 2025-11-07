{
  lib,
  config,
  ...
}: let
  inherit (lib) singleton;

  inherit
    (lib.custom.colors)
    gray1
    gray2
    white3
    blue0
    cyan_bright
    red_bright
    ;
in {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        origin = "top-right";
        separator_color = gray2;
        font = "${config.custom.fonts.regular} 14";
        icon_theme = config.gtk.iconTheme.name;
        width = "(250, 400)";
        offset = "(30, 30)";
        alignment = "center";
        browser = "helium -new-tab";
        corner_radius = 8;
        dmenu = ''
          rofi -dmenu -p 'Dunst' -mesg 'Context menu' -theme '${config.xdg.configHome}/rofi/themes/selecter.rasi'
        '';
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
        background = gray1;
        foreground = white3;
        frame_color = blue0;
        timeout = 5;
      };
      urgency_critical = {
        background = gray1;
        foreground = white3;
        frame_color = red_bright;
        timeout = 12;
      };
      urgency_low = {
        background = gray1;
        foreground = white3;
        frame_color = cyan_bright;
        timeout = 3;
      };
      # play sound depens on urgency level
      # but exclude spotify and mpd
      play_sound = {
        summary = "*";
        script = "dunst-sound";
      };
    };
  };

  programs.niri.settings = {
    binds = {
      "Mod+N" = {
        action.spawn = ["dunstctl" "history-pop"];
        hotkey-overlay.title = ''<span foreground="#9FC6C5">[󰎟 Dunst]</span> Notification History'';
      };
      "Mod+Shift+N" = {
        action.spawn = ["dunstctl" "close-all"];
        hotkey-overlay.title = ''<span foreground="#9FC6C5">[󰎟 Dunst]</span> Close all notifcations'';
      };
    };
    layer-rules = [
      {
        matches = singleton {
          namespace = "^(notifications)";
        };
        block-out-from = "screen-capture";
      }
    ];
  };
  systemd.user.services = {
    "dunst" = {
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
