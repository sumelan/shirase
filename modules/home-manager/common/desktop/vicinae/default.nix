{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) optional;
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
        normal = config.gtk.font.name;
        size = 14;
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
        action.spawn = ["vicinae" "toggle"];
        hotkey-overlay.title = ''<span foreground="#D79784">[󱓟 Vicinae]</span> Launcher'';
      };
      "Mod+V" = {
        action.spawn = ["vicinae" "vicinae://extensions/vicinae/clipboard/history"];
        hotkey-overlay.title = ''<span foreground="#D79784">[󱓟 Vicinae]</span> Clipboard History'';
      };
      "Mod+Shift+Alt+Backslash" = {
        action.spawn = ["dynamiccast-selecter"];
        hotkey-overlay.title = ''<span foreground="#D79784">[󱓟 Vicinae]</span> Dynamic Cast'';
      };
    };
  };

  custom.persist = {
    home.cache.directories = [
      ".local/share/vicinae"
    ];
  };
}
