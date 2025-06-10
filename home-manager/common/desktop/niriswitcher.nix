{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs = {
    niriswitcher = {
      enable = true;
    };
  };

  xdg.configFile = {
    "niriswitcher/config.toml".text = ''
      separate_workspaces = true
      double_click_to_hide = false
      center_on_focus = false
      log_level = "WARN"

      [appearance]
      icon_size = 128
      max_width = 800
      min_width = 600
      system_theme = "dark" # auto or light
      workspace_format = "{output}-{idx}" # {output}, {idx}, {name}

      [workspace]
      mru_sort_in_workspace = false
      mru_sort_across_workspace = true

      [appearance.animation.reveal]
      hide_duration = 200
      show_duration = 200
      easing = "ease-out-cubic"

      [appearance.animation.resize]
      duration = 200
      easing = "ease-in-out-cubic"

      [appearance.animation.workspace]
      duration = 200
      transition = "slide"

      [appearance.animation.switch]
      duration = 200
      easing = "ease-out-cubic"

      [keys]
      modifier = "Alt"

      [keys.switch]
      next = "Tab"
      prev = "Shift+Tab"

      [keys.window]
      close = "q"
      abort = "Escape"

      [keys.workspace]
      next = "grave"
      prev = "Shift+asciitilde"
    '';

    "niriswitcher/style.css".text =
      with config.lib.stylix.colors.withHashtag;
      let
        opacity = lib.toHexString (builtins.ceil (config.stylix.opacity.popups * 255));
      in
      ''
        :root {
          --bg-color: ${base00}${opacity};
          --label-color: ${base05};
          --alternate-label-color: ${base01};
          --dim-label-color: ${base03};
          --border-color: ${base02};
          --highlight-color: ${base05}95;
          --urgency-color: ${base09};
          --indicator-focus-color: ${base0D}95;
          --indicator-color: ${base06}95;
        }

        #niriswitcher.background {
          background-color: transparent;
        }

        #niriswitcher {
          background-color: transparent;
          padding: 40px;
        }

        #main-view {
          background-color: var(--bg-color);
          border-radius: 22px;
          border: 1px solid var(--border-color);
          padding: 10px 20px 10px;
          box-shadow: 0 0 20px 5px rgba(0,0,0,.3),
            0 0 13px 8px rgba(0,0,0,.2);
        }

        .workspace scrollbar, .workspace scrollbar * {
          background-color: transparent;
          min-width: 0px;
          min-height: 0px;
          opacity: 0;
        }

        .workspace scrollbar,
        .workspace scrollbar slider {
          background: transparent;
          min-width: 6px;
          min-height: 6px;
        }


        #application-title {
          background: transparent;
          color: var(--label-color);
          transition: all 0.2s ease-in-out;
        }

        #workspace-name {
          transition: all 0.2s ease-in-out;
          background-color: var(--highlight-color);
          color: var(--alternate-label-color);
          border-radius: 22px;
          padding: 3px 9px;
        }


        #workspaces {
          margin: 5px 10px 5px;
        }

        .workspace-indicator {
          background-color: var(--indicator-color);
          transition: background 200ms 20ms;
          margin:0;
        }

        .workspace-indicator:first-child {
          border-radius: 20% 20% 0 0;
        }

        .workspace-indicator:last-child {
          border-radius: 0 0 20% 20%;
        }

        .workspace-indicator.selected {
          background-color: var(--indicator-focus-color);
        }

        .workspace-indicator:hover {
          background-color: var(--indicator-focus-color);
        }

        #workspace-indicators {
          background: transparent;
          margin-top: 22px;
          margin-bottom: 22px;
          margin-right: 2px;
        }


        .application {
          background-color: transparent;
        }

        .application-icon {
          transition: -gtk-icon-filter 0.2s ease-in-out;
          padding: 10px 15px 10px;
          -gtk-icon-shadow: 0 1px 1px hsl(0deg 0% 0% / 0.075),
            0 2px 2px hsl(0deg 0% 0% / 0.075),
            0 4px 4px hsl(0deg 0% 0% / 0.075),
            0 8px 8px hsl(0deg 0% 0% / 0.075),
            0 16px 16px hsl(0deg 0% 0% / 0.075);
        }

        .application-name {
          transition: opacity 0.2s ease;
          opacity: 0;
          color: var(--dim-label-color);
          margin-top: 3px;
        }

        .application.selected .application-name {
          opacity: 1;
          color: var(--label-color);
        }

        .application.urgent .application-icon {
          animation-timing-function: linear;
          animation: urgency-pulse-animation 2.5s infinite;
        }

        @keyframes urgency-pulse-animation {
          0% {
            -gtk-icon-filter: drop-shadow(0 0 2px var(--urgency-color));
          }

          25% {
            -gtk-icon-filter: drop-shadow(0 0 5px var(--urgency-color));
          }

          50% {
            -gtk-icon-filter: drop-shadow(0 0 10px var(--urgency-color));
          }

          75% {
            -gtk-icon-filter: drop-shadow(0 0 5px var(--urgency-color));
            }

          100% {
            -gtk-icon-filter: drop-shadow(0 0 2px var(--urgency-color));
          }
        }

        .application.focused .application-name {
          opacity: 1;
          color: var(--dim-label-color);
        }

        .application.selected .application-icon {
          transition: background-color 0.1s ease-in;
          border-radius: 10%;
          background-color: var(--highlight-color);
        }
      '';
  };

  programs.niri.settings = {
    spawn-at-startup = [
      {
        command = [ "${lib.getExe pkgs.niriswitcher}" ];
      }
    ];
    binds = with config.lib.niri.actions; {
      "Alt+Tab" = {
        # Using USR1 to trigger niriswitcher has been deprecated on version 0.60
        action = spawn "pkill" "-USR1" "niriswitcher";
        repeat = false;
        hotkey-overlay.title = "Switch Windows";
      };
    };
  };
}
