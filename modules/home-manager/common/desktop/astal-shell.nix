{
  inputs,
  pkgs,
  ...
}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      gnome-calendar
      gnome-weather
      wf-recorder
      ;
  };

  services.astal-shell = {
    enable = true;
    package = inputs.astal-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;

    # Configure display margins
    displays = {
      "LG HDR 4K" = [580 300];
      "ASM-101QH" = [580 350];
      "Unknown" = [420 250];
    };

    # Configure theme
    theme = {
      colors = {
        background = {
          primary = "rgba(36, 41, 51, 0.8)"; # gray0
          secondary = "rgba(67, 76, 94, 0.6)"; # gray3
        };
        text = {
          primary = "rgba(235, 239, 244, 1.0)"; # white3
          secondary = "rgba(192, 200, 216, 0.8)"; # white0
          focused = "rgba(216, 222, 233, 1.0)"; # white1
          unfocused = "rgba(229, 233, 240, 0.6)"; # white2
        };
        accent = {
          primary = "rgba(94, 127, 172, 0.8)"; # blue0
          secondary = "rgba(136, 192, 208, 0.6)"; # blue2
          border = "rgba(129, 161, 193, 0.4)"; # blue1
          overlay = "rgba(129, 161, 193, 0.2)";
        };
        status = {
          success = "rgba(177, 200, 157, 0.8)"; # green_bright
          warning = "rgba(239, 212, 159, 0.8)"; # yellow_bright
          error = "rgba(197, 114, 122, 0.8)"; # red_bright
        };
      };
      opacity = {
        high = 1.0;
        medium = 0.8;
        low = 0.6;
      };
      font = {
        sizes = {
          small = "2.0em";
          normal = "2.5em";
          large = "3.0em";
        };
        weights = {
          normal = "normal";
          bold = "bold";
        };
      };
      spacing = {
        small = "4px";
        medium = "8px";
        large = "16px";
      };
      borderRadius = {
        small = "2px";
        medium = "4px";
        large = "9999px";
      };
    };
  };

  programs.niri.settings = {
    binds = {
      "XF86AudioRaiseVolume" = {
        action.spawn = ["volume-control" "up"];
      };
      "XF86AudioLowerVolume" = {
        action.spawn = ["volume-control" "down"];
      };
      "XF86AudioMute" = {
        action.spawn = ["volume-control" "mute"];
      };
      "XF86AudioNext" = {
        action.spawn = ["media-control" "next"];
      };
      "XF86AudioPlay" = {
        action.spawn = ["media-control" "play-pause"];
      };
      "XF86AudioPrev" = {
        action.spawn = ["media-control" "previous"];
      };
      "XF86AudioStop" = {
        action.spawn = ["media-control" "stop"];
      };
      "XF86MonBrightnessUp" = {
        action.spawn = ["brightness-control" "up"];
      };
      "XF86MonBrightnessDown" = {
        action.spawn = ["brightness-control" "down"];
      };
    };
    window-rules = [
      {
        matches = [
          {app-id = "^org.gnome.Calendar$";}
          {app-id = "^org.gnome.Weather$";}
        ];
        open-floating = true;
      }
    ];
  };
  custom.persist = {
    home.cache.directories = [
      ".cache/astal"
    ];
  };
}
