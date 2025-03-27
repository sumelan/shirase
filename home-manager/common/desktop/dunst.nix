{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libnotify
  ];

  services.dunst = {
    enable = true;
    settings = {
      global = {
        origin = "bottom-right";
        offset = "(20, 20)";
        alignment = "center";
        browser = "librewolf -new-tab";
        corner_radius = 8;
        dmenu = "rofi -dmenu -p dunst";
        enable_recursive_icon_lookup = true;
        ellipsize = "end";
        follow = "mouse";
        frame_width = 4;
        max_icon_size = 72;
        mouse_left_click = "do_action";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_current";
        separator_height = 1;
        show_indicators = "no";
      };

      urgency_critical = {
        timeout = 0;
      };

      urgency_low = {
        timeout = 10;
      };

      urgency_normal = {
        timeout = 10;
      };
    };
  };
  stylix.targets.dunst.enable = true;
}
