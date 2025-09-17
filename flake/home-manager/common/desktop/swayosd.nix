{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.custom = {
    swayosd.enable =
      mkEnableOption "Swayosd" // {default = true;};
  };

  config = mkIf config.custom.swayosd.enable {
    services.swayosd = {
      enable = true;
      stylePath = "${config.xdg.configHome}/swayosd/style.scss";
      topMargin = 1.0;
    };

    xdg.configFile."swayosd/style.scss".text = with config.lib.stylix.colors.withHashtag;
    # scss
      ''
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
      #  "XF86AudioRaiseVolume" = lib.custom.niri.runCmd {
      # cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --output-volume raise";
      # };
      #"XF86AudioLowerVolume" = lib.custom.niri.runCmd {
      # cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --output-volume lower";
      #};
      #"XF86AudioMute" = lib.custom.niri.runCmd {
      # cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --output-volume mute-toggle";
      # };
      # "XF86AudioMicMute" = lib.custom.niri.runCmd {
      # cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --input-volume mute-toggle";
      # };
      # brightness
      # "XF86MonBrightnessUp" = lib.custom.niri.runCmd {
      #   cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --brightness raise";
      # };
      # "XF86MonBrightnessDown" = lib.custom.niri.runCmd {
      #   cmd = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --brightness lower";
      # };

      "XF86AudioPlay" = {
        action.spawn = ["swayosd-client" "--monitor" "${config.lib.monitors.mainMonitorName}" "--playerctl=play-pause"];
        allow-when-locked = true;
      };
      "XF86AudioPause" = {
        action.spawn = ["swayosd-client" "--monitor" "${config.lib.monitors.mainMonitorName}" "--playerctl=play-pause"];
        allow-when-locked = true;
      };
      "XF86AudioNext" = {
        action.spawn = ["swayosd-client" "--monitor" "${config.lib.monitors.mainMonitorName}" "--playerctl=next"];
        allow-when-locked = true;
      };
      "XF86AudioPrev" = {
        action.spawn = ["swayosd-client" "--monitor" "${config.lib.monitors.mainMonitorName}" "--playerctl=previous"];
        allow-when-locked = true;
      };

      # fcitx5
      "Ctrl+Space" = {
        action.spawn = ["sh" "-c" "fcitx5-remote -t && swayosd-client --monitor ${config.lib.monitors.mainMonitorName} --custom-message=$(fcitx5-remote -n) --custom-icon=input-keyboard"];
        hotkey-overlay.title = ''<span foreground="${config.lib.stylix.colors.withHashtag.base0E}">[Fcitx5]</span> Switch Active/Inactive'';
      };
    };
  };
}
