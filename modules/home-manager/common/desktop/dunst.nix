{
  lib,
  config,
  ...
}: let
  inherit (lib) singleton;

  inherit
    (lib.custom.colors)
    gray1
    white3
    blue1
    cyan_bright
    red_bright
    ;
in {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        origin = "top-right";
        font = "${config.custom.fonts.monospace} 14";
        icon_theme = config.gtk.iconTheme.name;
        enable_recursive_icon_lookup = true;
        width = "(250, 400)";
        offset = "(30, 30)";
        frame_width = 4;
        corner_radius = 8;
        max_icon_size = 72;
        # If value is greater than 0, separator_height will be ignored
        # and a border of size frame_width will be drawn around each notification instead.
        gap_size = 0;
        separator_height = 2;
        # values: [auto/foreground/frame/#RRGGBB]
        separator_color = "auto";
        alignment = "center";
        dmenu = ''
          rofi -dmenu -p 'Dunst' -mesg 'Context menu' -theme '${config.xdg.configHome}/rofi/themes/selecter.rasi'
        '';
        browser = "helium -new-tab";
        ellipsize = "end";
        follow = "mouse";
        mouse_left_click = "do_action";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_current";
        show_indicators = "no";
      };
      urgency_normal = {
        background = gray1;
        foreground = white3;
        frame_color = blue1;
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
      # play sound except spotify and mpd
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
