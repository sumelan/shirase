# NOTE: To test gtklock, run `labwc -s "gtklock"`
{
  config,
  pkgs,
  ...
}: {
  environment.etc = {
    "xdg/gtklock/background.png".source = ./nix-nord-aurora.png;
  };

  programs.gtklock = {
    enable = true;
    modules = builtins.attrValues {
      inherit
        (pkgs)
        gtklock-playerctl-module
        gtklock-powerbar-module
        gtklock-userinfo-module
        ;
    };
    config = {
      main = {
        gtk-theme = config.hm.gtk.theme.name;
        background = true;
        time-format = "%H:%M";
        date-format = "%m月 %d日 %A";
        follow-focus = true;
        idle-hide = true;
        idle-timeout = 10;
        start-hidden = true;
        # Command to execute after locking
        lock-command = "";
        # Command to execute after unlocking
        unlock-command = "";
      };
      playerctl = {
        art-size = 64;
        position = "under-clock";
        show-hidden = false;
      };
      powerbar = {
        show-labels = false;
        linked-buttons = false;
        reboot-command = "systemctl reboot";
        poweroff-command = "systemctl poweroff";
        suspend-command = "systemctl suspend";
        logout-command = "niri msg action quit --skip-confirmation";
      };
      userinfo = {
        horizontal-layout = false;
        under-clock = false;
        image-size = 128;
      };
    };
    style =
      # css
      ''
        * {
            all: unset;
        }

        window {
            background-image: url("/etc/xdg/gtklock/background.png");
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            background-color: rgba(36, 41, 51, 0.5);
        }

        #window-box {
            box-shadow: inset 0 0 0 1px rgba(67, 76, 94, 0.02);
            border-radius: 12px;
            margin: 18px;
            background-color: rgba(67, 76, 94, 1.0);
            color: rgba(235, 239, 244, 1.0);
            padding: 14px 50px;
        }

        #window-box #clock-label {
            font-size: 6em;
            text-shadow: 2px 2px 2px rgba(67, 76, 94, 0.5);
        }

        #window-box #unlock-button {
            border-radius: 7px;
            color: rgba(235, 239, 244, 1.0);
            background-color: rgba(94, 127, 172, 0.08);
            box-shadow: inset 0 0 0 1px rgba(67, 76, 94, 0.002);
            padding: 6px 12px;
        }
        #window-box #unlock-button:hover {
            box-shadow: inset 0 0 0 1px rgba(67, 76, 94, 0.002);
            background-color: rgba(94, 127, 172, 0.16);
            color: rgba(235, 239, 244, 1.0);
        }
        #window-box #unlock-button:active {
            box-shadow: inset 0 0 0 1px rgba(67, 76, 94, 0.002);
            background-color: rgba(177, 200, 157, 1.0);
            color: rgba(36, 41, 51, 0.8)
        }

        #window-box #input-field {
            border-radius: 7px;
            color: rgba(235, 239, 244, 1.0);
            background-color: rgba(94, 127, 172, 0.08);
            box-shadow: inset 0 0 0 1px rgba(67, 76, 94, 0.002);
            min-height: 32px;
            padding-left: 0.4em;
            border: 1px solid rgba(67, 76, 94, 0.002);
        }
        #window-box #input-field:hover {
            box-shadow: inset 0 0 0 1px rgba(67, 76, 94, 0.002);
            background-color: rgba(94, 127, 172, 0.16);
            color: rgba(235, 239, 244, 1.0);
        }
        #window-box #input-field:active {
            box-shadow: inset 0 0 0 1px rgba(67, 76, 94, 0.002);
            background-color: rgba(94, 127, 172, 1.0);
            color: rgba(177, 200, 157, 1.0)
        }
        #window-box #input-field:focus {
            border-color: rgba(94, 127, 172, 1.0);
        }

        #window-box #warning-label {
            color: rgba(239, 212, 159, 1.0);
        }

        #window-box #error-label {
            color: rgba(197, 114, 122, 1.0);
        }
      '';
  };

  hm = {
    programs.niri.settings.binds = {
      "Mod+Alt+L" = {
        action.spawn = ["gtklock"];
        allow-when-locked = true;
        hotkey-overlay.title = ''<span foreground="#9FC6C5">[ Gtklock]</span> Lock Screen'';
      };
    };
  };
}
