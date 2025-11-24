{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) optional singleton;
  inherit (lib.custom.colors) black0 yellow_dim;
  inherit (lib.custom.niri) spawn hotkey;
in {
  imports = [
    ./shell.nix
  ];

  services.vicinae = {
    enable = true;
    autoStart = true;
    useLayerShell = true;
    settings = {
      closeOnFocusLoss = true;
      faviconService = "twenty"; # twenty | google | none
      font = {
        normal = config.custom.fonts.regular;
        size = 12;
      };
      keybinding = "default";
      keybinds = {
        "action.copy" = "control+shift+C";
        "action.copy-name" = "control+shift+.";
        "action.copy-path" = "control+shift+,";
        "action.dangerous-remove" = "control+shift+X";
        "action.duplicate" = "control+D";
        "action.edit" = "control+E";
        "action.edit-secondary" = "control+shift+E";
        "action.move-down" = "control+shift+ARROWDOWN";
        "action.move-up" = "control+shift+ARROWUP";
        "action.new" = "control+N";
        "action.open" = "control+O";
        "action.pin" = "control+shift+P";
        "action.refresh" = "control+R";
        "action.remove" = "control+X";
        "action.save" = "control+S";
        "open-search-filter" = "control+P";
        "open-settings" = "control+,";
        "toggle-action-panel" = "control+J";
      };
      popToRootOnClose = false;
      rootSearch.searchFiles = false;
      theme = {
        iconTheme = config.gtk.iconTheme.name;
        name = "nord";
      };
      window = {
        csd = true;
        opacity = 0.95;
        rounding = 10;
      };
    };

    extensions = let
      ext = fn: inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.mkVicinaeExtension fn;
    in
      [
        (ext {
          pname = "bluetooth";
          src = "${pkgs.custom.vicinae-extensions.src}/extensions/bluetooth";
        })
        # (ext {
        #   pname = "systemd";
        #   src = "${pkgs.custom.vicinae-extensions.src}/extensions/systemd";
        # })
        (ext {
          pname = "power-profile-daemon";
          src = "${pkgs.custom.vicinae-extensions.src}/extensions/power-profile";
        })
        (ext {
          pname = "niri";
          src = "${pkgs.custom.vicinae-extensions.src}/extensions/niri";
        })
        (ext {
          pname = "nix";
          src = "${pkgs.custom.vicinae-extensions.src}/extensions/nix";
        })
      ]
      ++ optional config.custom.wifi.enable (ext {
        pname = "wifi";
        src = "${pkgs.custom.vicinae-extensions.src}/extensions/wifi-commander";
      });
  };

  programs.niri.settings = {
    binds = {
      "Mod+Space" = {
        action.spawn = spawn "vicinae toggle";
        hotkey-overlay.title = hotkey {
          color = yellow_dim;
          name = "󱓟  Vicinae";
          text = "Launcher";
        };
      };
      "Mod+V" = {
        action.spawn = spawn "vicinae vicinae://extensions/vicinae/clipboard/history";
        hotkey-overlay.title = hotkey {
          color = yellow_dim;
          name = "󱓟  Vicinae";
          text = "Clipboard History";
        };
      };
      "Mod+X" = {
        action.spawn = spawn "vicinae vicinae://extensions/botkooper/power-profile/power-profile";
        hotkey-overlay.title = hotkey {
          color = yellow_dim;
          name = "󱓟  Vicinae";
          text = "Power-profile";
        };
      };
      "Mod+Ctrl+Backslash" = {
        action.spawn = spawn "dynamiccast-selecter";
        hotkey-overlay.title = hotkey {
          color = yellow_dim;
          name = "󱓟  Vicinae";
          text = "Dynamic Cast";
        };
      };
    };
    layer-rules = [
      {
        matches = singleton {
          namespace = "^vicinae";
        };
        geometry-corner-radius = {
          bottom-left = 10.0;
          bottom-right = 10.0;
          top-left = 10.0;
          top-right = 10.0;
        };
        shadow = {
          enable = true;
          softness = 20;
          spread = 10;
          offset = {
            x = 0;
            y = 0;
          };
          color = black0 + "90";
        };
        opacity = 0.95;
      }
    ];
  };

  custom.persist = {
    home.cache.directories = [
      ".local/share/vicinae"
    ];
  };
}
