{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    librewolf.enable = mkEnableOption "librewolf" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.librewolf.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.librewolf;
      languagePacks = ["ja" "en-US"];
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
          "addon@darkreader.org"= {
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
    programs.niri.settings.window-rules = [
      {
        matches = [
          { 
            app-id = "^(librewolf)$";
            title = "^(ピクチャーインピクチャー)$"; # obey language settings?
          }
          {
            app-id = "^(librewolf)$";
            title = "^(Save File)$"; # save file dialog
          }
          {
            app-id = "^(librewolf)$";
            title = "^(.*)(wants to save)$"; # save image diaslog
          }
          {
            app-id = "^(librewolf)$";
            title = "^(拡張機能:(.*))$";
          }
        ];
        open-floating = true;
        default-floating-position = {
          x = 10;
          y = 10;
          relative-to = "top-right";
        };
      }
    ];

    xdg.mimeApps.defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };

    custom.persist = {
      home.directories = [
        ".cache/librewolf"
        ".librewolf"
      ];
    };
  };
}
