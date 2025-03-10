{
  lib,
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    languagePacks = [
      "ja"
      "en-US"
    ];
    policies = {
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"

      ExtensionSettings = {
        # blocks all addons except the ones specified below
        "*".installation_mode = "blocked";
        # bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        # darkreader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        # sponsorblock
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  # set default browser
  home.sessionVariables = {
    DEFAULT_BROWSER = lib.getExe pkgs.librewolf;
    BROWSER = lib.getExe pkgs.librewolf;
  };

  # niri window-rules
  # NOTE: bitwarden window cannot be floated on this method
  # https://github.com/hyprwm/Hyprland/issues/3835
  programs.niri.settings.window-rules = [
    {
      matches = [ { app-id = "^(librewolf)$"; } ];
      default-column-width = {
        proportion = 0.8;
      };
    }
    {
      matches = [
        {
          app-id = "^(librewolf)$";
          title = "^(ピクチャーインピクチャー)$";
        }
        {
          app-id = "^(librewolf)$";
          title = "^(Save File)$";
        }
        {
          app-id = "^(librewolf)$";
          title = "^(.*)(wants to save)$";
        }
      ];
      default-column-width.proportion = 0.4;
      default-window-height.proportion = 0.4;
      open-floating = true;
    }
  ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "x-scheme-handler/about" = "librewolf.desktop";
    "x-scheme-handler/unknown" = "librewolf.desktop";
  };
  stylix.targets.librewolf = {
    enable = true;
    firefoxGnomeTheme.enable = true;
  };

  custom.persist = {
    home.directories = [
      ".cache/librewolf"
      ".librewolf"
    ];
  };
}
