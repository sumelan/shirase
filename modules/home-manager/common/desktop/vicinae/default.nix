{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) optional singleton;
  inherit (lib.custom.colors) black0 magenta_bright;
  inherit (lib.custom.niri) spawn hotkey;
  inherit (config.lib.vicinae) mkExtension;
in {
  imports = [
    ./shell.nix
  ];

  programs.vicinae = {
    enable = true;
    systemd.enable = true;
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
    extensions =
      [
        (mkExtension {
          name = "bluetooth";
          src = "${pkgs.custom.vicinae-extensions.src}/extensions/bluetooth";
        })
        (mkExtension {
          name = "firefox";
          src = "${pkgs.custom.vicinae-extensions.src}/extensions/firefox";
        })
        (mkExtension {
          name = "niri";
          src = "${pkgs.custom.vicinae-extensions.src}/extensions/niri";
        })
        (mkExtension {
          name = "nix";
          src = "${pkgs.custom.vicinae-extensions.src}/extensions/nix";
        })
        (mkExtension {
          name = "power-profile";
          src = "${pkgs.custom.vicinae-extensions.src}/extensions/power-profile";
        })
        # (mkExtension {
        #   name = "systemd";
        #   src = "${pkgs.custom.vicinae-extensions.src}/extensions/systemd";
        # })
      ]
      ++ optional config.custom.wifi.enable (mkExtension {
        name = "wifi-commander";
        src = "${pkgs.custom.vicinae-extensions.src}/extensions/wifi-commander";
      });
  };

  programs.niri.settings = {
    binds = {
      "Mod+Space" = {
        action.spawn = spawn "vicinae toggle";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "  Vicinae";
          text = "Launcher";
        };
      };
      "Mod+V" = {
        action.spawn = spawn "vicinae vicinae://extensions/vicinae/clipboard/history";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "  Vicinae";
          text = "Clipboard History";
        };
      };
      "Mod+X" = {
        action.spawn = spawn "vicinae vicinae://extensions/botkooper/power-profile/power-profile";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "  Vicinae";
          text = "Power-profile";
        };
      };
      "Mod+Shift+D" = {
        action.spawn = spawn "dynamiccast-selecter";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "  Vicinae";
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
