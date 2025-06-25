{
  lib,
  config,
  pkgs,
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

  programs.niri.settings.binds =
    with config.lib.niri.actions;
    let
      ush = program: spawn "sh" "-c" "uwsm app -- ${program}";
      osdCommand = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName}";
    in
    {
      # audio
      "XF86AudioRaiseVolume" = {
        action = ush "${osdCommand} --output-volume raise";
        allow-when-locked = true; # work even when the session is locked
      };
      "XF86AudioLowerVolume" = {
        action = ush "${osdCommand} --output-volume lower";
        allow-when-locked = true;
      };
      "XF86AudioMute" = {
        action = ush "${osdCommand} --output-volume mute-toggle";
        allow-when-locked = true;
      };
      "XF86AudioMicMute" = {
        action = ush "${osdCommand} --input-volume mute-toggle";
        allow-when-locked = true;
      };
      "XF86AudioPlay" = {
        action = ush "${osdCommand} --playerctl=play-pause";
        allow-when-locked = true;
      };
      "XF86AudioPause" = {
        action = ush "${osdCommand} --playerctl=play-pause";
        allow-when-locked = true;
      };
      "XF86AudioNext" = {
        action = ush "${osdCommand} --playerctl=next";
        allow-when-locked = true;
      };
      "XF86AudioPrev" = {
        action = ush "${osdCommand} --playerctl=previous";
        allow-when-locked = true;
      };

      # brightness
      "XF86MonBrightnessUp" = {
        action = ush "${osdCommand} --brightness raise";
        allow-when-locked = true;
      };
      "XF86MonBrightnessDown" = {
        action = ush "${osdCommand} --brightness lower";
        allow-when-locked = true;
      };

      # fcitx5
      "Ctrl+Space" = {
        action = ush "fcitx5-remote -t && ${osdCommand} --custom-message=$(fcitx5-remote -n) --custom-icon=input-keyboard";
      };

      # clear clipboard cache
      "Mod+Ctrl+V" = {
        action = ush "rm $XDG_CACHE_HOME/cliphist/db && ${osdCommand} --custom-message='Clipboard Cleared' --custom-icon=edit-paste";
        hotkey-overlay.title = "Clear Clipboard History";
      };
      "Mod+Alt+N" = {
        action = ush "${lib.getExe' pkgs.dunst "dunstctl"} history-clear && ${osdCommand}  --custom-message='History Cleared' --custom-icon=notification";
        hotkey-overlay.title = "Clear Notification History";
      };
    };
}
