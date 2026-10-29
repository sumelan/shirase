{config}: {
  config_version = 14;

  audio = {
    enable_sounds = true;
  };

  backdrop = {
    enabled = true;
    blur_intensity = 0.2;
  };

  brightness = {
    enable_ddcutil = true;
    sync_all_monitors = true;
  };

  calendar = {
    enabled = true;
    reminders = {
      enabled = false;
    };
    account = {
      "sumelan_google" = {
        color = "primary";
        name = "Google";
        type = "google";
      };
    };
  };

  location = {
    auto_locate = true;
  };

  lockscreen = {
    blur_intensity = 0.300;
  };

  osd = {
    background_opacity = 0.60;
    position = "bottom_center";
    position_vertical = "bottom_center";
  };

  plugin_settings = {
    "noctalia/mpvpaper" = {
      picker_placement = "floating";
      picker_position = "top_left";
      video_directory = "~/Videos/Wallpapers/blueArchive";
    };
  };

  plugins = {
    enabled = ["noctalia/mpvpaper"];
  };

  shell = {
    avatar_path = "/home/sumelan/.face";
    font_family = "Montserrat";
    polkit_agent = true;
    settings_show_advanced = true;
    setup_wizard_enabled = false;

    greeter_sync = {
      auto_sync = true;
    };

    lang = "en";

    launcher = {
      layout = "simple";
      categories = false;
    };

    panel = {
      shadow = false;
      clipboard_position = "bottom_center";
      control_center_placement = "attached";
      launcher_placement = "floating";
      open_near_click_control_center = true;
      session_placement = "floating";
      session_position = "bottom_center";
      transparency_mode = "glass";
      wallpaper_placement = "floating";
      wallpaper_position = "top_left";
    };

    screen_corners = {
      enabled = true;
      size = 40;
    };

    screenshot = {
      confirm_region = true;
      directory = "/home/sumelan/Pictures/Screenshots";
      pipe_command = "";
      pipe_to_command = false;
    };
  };

  theme = {
    community_palette = "Catppuccin Frappe Pink";
    mode = "dark";
    source = "community";

    templates = {
      builtin_ids = ["niri"];
      community_ids = [];
    };
  };

  wallpaper = {
    directory = "${config.hjem.users.sumelan.directory}/Pictures/Wallpapers";
  };
}
