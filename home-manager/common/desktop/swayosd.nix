{
  lib,
  config,
  ...
}:
{
  services.swayosd = {
    enable = true;
    # NOTE: options "swayosd.display" exists, but not work
    stylePath = "${config.xdg.configHome}/swayosd/style.scss";
    topMargin = 1.0;
  };

  xdg.configFile."swayosd/style.scss".text = with config.lib.stylix.colors.withHashtag; ''
    window {
      border-radius: 999px;
      border: 2px solid alpha(${base02}, ${toString config.stylix.opacity.popups});
      background: alpha(${base00}, ${toString config.stylix.opacity.popups});
    }

    image,
    label {
      color: ${base05};
    }

    progressbar {
      min-height: 6px;
      border-radius: 999px;
      background: transparent;
      border: none;
    }

    progressbar:disabled,
    image:disabled {
      opacity: 0.5;
    }

    trough {
      min-height: inherit;
      border-radius: inherit;
      border: none;
      background: alpha(${base05}, 0.5);
    }

    progress {
      min-height: inherit;
      border-radius: inherit;
      border: none;
      background: ${base05};
    }
  '';

  programs.niri.settings.binds = {
    # audio
    "XF86AudioRaiseVolume" = lib.custom.niri.runCmd {
      cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --output-volume raise";
      locked = "allow";
    };
    "XF86AudioLowerVolume" = lib.custom.niri.runCmd {
      cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --output-volume lower";
      locked = "allow";
    };
    "XF86AudioMute" = lib.custom.niri.runCmd {
      cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --output-volume mute-toggle";
      locked = "allow";
    };
    "XF86AudioMicMute" = lib.custom.niri.runCmd {
      cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --input-volume mute-toggle";
      locked = "allow";
    };
    "XF86AudioPlay" = lib.custom.niri.runCmd {
      cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --playerctl=play-pause";
      locked = "allow";
    };
    "XF86AudioPause" = lib.custom.niri.runCmd {
      cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --playerctl=play-pause";
      locked = "allow";
    };
    "XF86AudioNext" = lib.custom.niri.runCmd {
      cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --playerctl=next";
      locked = "allow";
    };
    "XF86AudioPrev" = lib.custom.niri.runCmd {
      cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --playerctl=previous";
      locked = "allow";
    };
    # brightness
    "XF86MonBrightnessUp" = lib.custom.niri.runCmd {
      cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --brightness raise";
      locked = "allow";
    };
    "XF86MonBrightnessDown" = lib.custom.niri.runCmd {
      cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --brightness lower";
      locked = "allow";
    };

    # fcitx5
    "Ctrl+Space" = lib.custom.niri.runCmd {
      cmd = "fcitx5-remote -t";
      osd = "swayosd";
      osdArgs = "--monitor ${config.lib.monitors.mainMonitorName} --custom-message=(fcitx5-remote -n) --custom-icon=input-keyboard";
    };

    # clear clipboard cache
    "Mod+Ctrl+V" = lib.custom.niri.runCmd {
      cmd = "rm $XDG_CACHE_HOME/cliphist/db";
      osd = "swayosd";
      osdArgs = "--monitor ${config.lib.monitors.mainMonitorName} --custom-message='Clipboard Cleared' --custom-icon=edit-paste";
    };
  };
}
