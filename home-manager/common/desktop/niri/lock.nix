{
  config,
  user,
  ...
}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 0;
      };
      background = {
        path = "/home/${user}/.config/hypr/hyprlock.png";
        blur_size = 2;
        blur_passes = 2;
      };
      input-field = {
        size = "300, 50";
        outline_thickness = 3;
        dots_size = 0.25;
        dots_spacing = 0.15;
        dots_center = true;
        dots_rounding = -1;
        fade_on_empty = false;
        fade_timeout = 1000;
        placeholder_text = "<span foreground=\"##${config.lib.stylix.colors.base05}\">󰌾  Logged in as <span foreground=\"##${config.lib.stylix.colors.base0D}\"><i>$USER</i></span></span>";
        hide_input = false;
        rounding = -1;
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        fail_transition = 300;
        capslock_color = "rgb(${config.lib.stylix.colors.base0A})";
        position = "0, -70";
        halign = "center";
        valign = "center";
      };
      image = {
        path = "/home/${user}/.face.icon";
        size = 150;
        border_color = "rgb(${config.lib.stylix.colors.base0D})";
        position = "0, 75";
        halign = "center";
        valign = "center";
      };
      label = [
        {
          text = "$TIME";
          color = "rgb(${config.lib.stylix.colors.base01})";
          font_size = 90;
          font_family = config.stylix.fonts.sansSerif.name;
          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        {
          text = "cmd[update:43200000] echo \"$(date +\"%B %d, %A\")\"";
          color = "rgb(${config.lib.stylix.colors.base01})";
          font_size = 25;
          font_family = config.stylix.fonts.sansSerif.name;
          position = "-30, -150";
          halign = "right";
          valign = "top";
        }
        {
          text = "cmd[update:1000] get_battery_info";
          color = "rgb(${config.lib.stylix.colors.base01})";
          font_size = 18;
          font_family = config.stylix.fonts.sansSerif.name;
          position = "-30, -210";
          halign = "right";
          valign = "top";
        }
        {
          text = "cmd[update:1000] get_media_info";
          color = "rgb(${config.lib.stylix.colors.base01})";
          font_size = 18;
          font_family = config.stylix.fonts.sansSerif.name;
          position = "-30, -253";
          halign = "right";
          valign = "top";
        }
      ];
    };
  };

  xdg.configFile."hypr/hyprlock.png" = {
    source = ../../../../hosts/lock.png;
  };

  stylix.targets.hyprlock.enable = true;
}

