{config, ...}: let
  inherit (config.lib.monitors) mainMonitorName;
in {
  programs = {
    hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
        };
        background = {
          monitor = mainMonitorName;
          path = "screenshot";
          color = "rgba(36, 41, 51, 1.0)"; # fallback
          blur_size = 2; # blur size (distance)
          blur_passes = 2; # the amount of passes to perform. '0' disables blurring
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
          placeholder_text = ''<span foreground="##242933">󰌾  Logged in as <span foreground="##CB775D"><i>$USER</i></span></span>'';
          outer_color = "rgba(36, 41, 51, 1.0)";
          inner_color = "rgba(236, 239, 244, 1.0)";
          font_color = "rgba(36, 41, 51, 1.0)";
          fail_color = "rgba(197, 114, 122, 1.0)";
          check_color = "rgba(239, 212, 159, 1.0)";
          hide_input = false;
          rounding = -1;
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = "rgba(197, 114, 122, 1.0)";
          position = "0, -100";
          halign = "center";
          valign = "center";
        };
        image = {
          path = "${config.home.homeDirectory}/.face";
          size = 280;
          border_color = "rgba(215, 151, 132, 1.0)";
          position = "0, 100";
          halign = "center";
          valign = "center";
        };
        label = [
          {
            text = "$TIME";
            color = "rgba(25, 29, 36, 1.0)";
            font_size = 12 * 9;
            font_family = config.custom.fonts.monospace;
            position = "-30, 0";
            halign = "right";
            valign = "top";
          }
          {
            text = ''cmd[update:43200000] echo "$(date +'%B %d, %A')"'';
            color = "rgba(25, 29, 36, 1.0)";
            font_size = 12 * 4;
            font_family = config.custom.fonts.monospace;
            position = "-30, -180";
            halign = "right";
            valign = "top";
          }
        ];
      };
    };

    niri.settings.binds = {
      "Mod+Alt+L" = {
        action.spawn = ["hyprlock"];
        allow-when-locked = true;
        hotkey-overlay.title = ''<span foreground="#9FC6C5">[ Hyprlock]</span> Lock Screen'';
      };
    };
  };
}
