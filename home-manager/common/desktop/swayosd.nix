{ config, user, ... }:
{
  services.swayosd = {
    enable = true;
    # NOTE: options "swayosd.display" exists, but not work
    stylePath = "/home/${user}/.config/swayosd/style.scss";
    topMargin = 1.0;
  };

  xdg.configFile."swayosd/style.scss".text = with config.lib.stylix.colors.withHashtag; ''
    window {
      border-radius: 999px;
      border: 2px solid alpha(${base0A}, ${toString config.stylix.opacity.popups});
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

  programs.niri.settings.binds =
    with config.lib.niri.actions;
    let
      sh = spawn "sh" "-c";
      osdCommand = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName}";
    in
    {
      # audio
      "XF86AudioRaiseVolume" = {
        action = sh "${osdCommand} --output-volume raise";
        allow-when-locked = true; # work even when the session is locked
      };
      "XF86AudioLowerVolume" = {
        action = sh "${osdCommand} --output-volume lower";
        allow-when-locked = true;
      };
      "XF86AudioMute" = {
        action = sh "${osdCommand} --output-volume mute-toggle";
        allow-when-locked = true;
      };
      "XF86AudioMicMute" = {
        action = sh "${osdCommand} --input-volume mute-toggle";
        allow-when-locked = true;
      };
      "XF86AudioPlay" = {
        action = sh "${osdCommand} --playerctl=play-pause";
        allow-when-locked = true;
      };
      "XF86AudioPause" = {
        action = sh "${osdCommand} --playerctl=play-pause";
        allow-when-locked = true;
      };
      "XF86AudioNext" = {
        action = sh "${osdCommand} --playerctl=next";
        allow-when-locked = true;
      };
      "XF86AudioPrev" = {
        action = sh "${osdCommand} --playerctl=previous";
        allow-when-locked = true;
      };

      # brightness
      "XF86MonBrightnessUp" = {
        action = sh "${osdCommand} --brightness raise";
        allow-when-locked = true;
      };
      "XF86MonBrightnessDown" = {
        action = sh "${osdCommand} --brightness lower";
        allow-when-locked = true;
      };

      # fcitx5
      "Ctrl+Space" = {
        action = sh "fcitx5-remote -t && ${osdCommand} --custom-message=$(fcitx5-remote -n) --custom-icon=input-keyboard";
      };
    };
}
