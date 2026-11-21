{
  config,
  pkgs,
  customLib,
  ...
}: let
  inherit (pkgs.lib) concatStringsSep;
  inherit (customLib.niri) hotkey;
in {
  hjem.users.sumelan.rum = {
    programs.dux-shell = {
      inherit (config.programs.dux-shell) enable package;
    };
  };

  environment.sessionVariables = {
    DMS_HIDE_TRAYIDS = concatStringsSep "," [
      "Fcitx"
    ];
  };

  custom = {
    wayland.windowManager.niri = {
      extraBinds = let
        duxKey = desc:
          hotkey {
            color = "#babbf1";
            name = "󰮤  Dux Shell";
            inherit desc;
          };
      in {
        "Mod+Space" = {
          _props.hotkey-overlay-title = duxKey "Application Launcher";
          spawn = ["dms" "ipc" "call" "spotlight" "toggle"];
        };
        "Mod+Y" = {
          _props.hotkey-overlay-title = duxKey "Clipboard Manager";
          spawn = ["dms" "ipc" "call" "clipboard" "toggle"];
        };
        "Mod+W" = {
          _props.hotkey-overlay-title = duxKey "Toggle Wallpapers";
          spawn = ["dms" "ipc" "call" "dash" "toggle" "wallpaper"];
        };
        "Mod+Shift+Right" = {
          _props.hotkey-overlay-title = duxKey "Wallpaper Cycle to Next";
          spawn = ["dms" "ipc" "call" "wallpaper" "next"];
        };
        "Mod+Shift+Left" = {
          _props.hotkey-overlay-title = duxKey "Wallpaper Cycle to Previous";
          spawn = ["dms" "ipc" "call" "wallpaper" "prev"];
        };
        "Mod+X" = {
          _props.hotkey-overlay-title = duxKey "Powermenu";
          spawn = ["dms" "ipc" "call" "powermenu" "toggle"];
        };
        "Mod+Comma" = {
          _props.hotkey-overlay-title = duxKey "Settings";
          spawn = ["dms" "ipc" "call" "settings" "toggle"];
        };
        "Mod+Shift+Ctrl+L" = {
          _props.hotkey-overlay-title = duxKey "Lock Screen";
          spawn = ["dms" "ipc" "call" "lock" "lock"];
        };
        "Print" = {spawn = ["dms" "ipc" "call" "niri" "screenshot"];};
        "Shift+Print" = {spawn = ["dms" "ipc" "call" "niri" "screenshotScreen"];};
        "Alt+Print" = {spawn = ["dms" "ipc" "call" "niri" "screenshotWindow"];};

        # media-key
        "XF86AudioRaiseVolume" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "call" "audio" "increment" "5%"];
        };
        "XF86AudioLowerVolume" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "call" "audio" "decrement" "5%"];
        };
        "XF86AudioMute" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "call" "audio" "mute"];
        };
        "XF86AudioPlay" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "call" "mpris" "playPause"];
        };
        "XF86AudioPrev" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "call" "mpris" "previous"];
        };
        "XF86AudioNext" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "call" "mpris" "next"];
        };
      };

      extraWindow-rule = [
        {
          match = [
            {_props.app-id._raw = ''r#"^dev.duxlabs.shell$"#'';}
          ];
          open-floating = true;
        }
        {
          match = [
            {_props.app-id._raw = ''r#"^dev.duxlabs.files$"#'';}
            {_props.app-id._raw = ''r#"^dev.duxlabs.calendar$"#'';}
          ];
          default-column-width._children = [
            {proportion = 0.500000;}
          ];
          default-window-height._children = [
            {proportion = 0.500000;}
          ];
          open-floating = true;
          block-out-from = "screen-capture";
        }
        {
          match = [
            {_props.title._raw = ''r#"^認証$"#'';} # polkit
          ];
          block-out-from = "screen-capture";
        }
      ];
    };

    fileSystem = {
      persist.home = {
        files = [
          ".config/dms/icc.json"
        ];

        directories = [
          ".config/dms/themes"
        ];
      };

      cache.home.directories = [
        ".cache/dms"
        ".local/state/dms"
      ];
    };
  };
}
