{lib, ...}: let
  inherit (lib.custom.colors) blue2;
  inherit (lib.custom.niri) spawn hotkey;
in {
  programs = {
    ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        alpha-blending = "linear-corrected";
        confirm-close-surface = false;
        copy-on-select = "clipboard";
        cursor-style = "bar";
        font-feature = "zero";
        font-size = 14;
        font-style = "Medium";
        minimum-contrast = 1.1;
        # run `ghostty +list-themes` to see available list
        theme = "Nord";
        window-decoration = false;
      };
    };

    niri.settings.binds = {
      "Mod+Return" = {
        action.spawn = spawn "ghostty";
        hotkey-overlay.title = hotkey {
          color = blue2;
          name = "󱙝  Ghostty";
          text = "Terminal Emulator";
        };
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/terminal" = "ghostty.desktop";
  };
}
