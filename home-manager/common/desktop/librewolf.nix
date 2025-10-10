{
  lib,
  config,
  pkgs,
  inputs,
  user,
  ...
}: let
  inherit
    (lib)
    concatStringsSep
    getExe
    ;

  configPath = ".config/.librewolf";
in {
  programs = {
    librewolf = {
      enable = true;
      languagePacks = [
        "en-US"
        "ja-JP"
      ];
      package = pkgs.librewolf.overrideAttrs (o: {
        # launch librewolf with user profile
        buildCommand =
          o.buildCommand
          + ''
            wrapProgram "$out/bin/librewolf" \
              --set 'HOME' '${config.xdg.configHome}' \
              --append-flags "${
              concatStringsSep " " [
                "--name librewolf"
                # load librewolf profile with same name as user
                "--profile ${config.home.homeDirectory}/${configPath}/${user}"
              ]
            }"
          '';
      });

      inherit configPath;

      profiles.${user} = {
        extensions = {
          force = true; # Whether to override all previous librewolf settings. This is required when using 'settings'.
          packages = builtins.attrValues {
            inherit
              (inputs.firefox-addons.packages.${pkgs.system})
              bitwarden
              darkreader
              sponsorblock
              ublock-origin
              ;
          };
        };

        settings = {
          "extensions.autoDisableScopes" = 0; # enable extensions immediately upon new install
          "privacy.clearOnShutdown_v2.cache" = false;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

        userChrome =
          # css
          ''
            /* remove useless urlbar padding */
            #customizableui-special-spring1 { display:none }
            #customizableui-special-spring2 { display:none }

            /* remove all tabs button and window controls */
            #alltabs-button { display:none }
            .titlebar-spacer { display:none }
            .titlebar-buttonbox-container { display:none }
          '';
      };
    };
    niri.settings = {
      binds = {
        "Mod+B" = {
          action.spawn = ["librewolf"];
          hotkey-overlay.title = ''<span foreground="${config.lib.stylix.colors.withHashtag.base0B}">[Application]</span> Librewolf'';
        };
      };
      # NOTE: bitwarden window cannot be floated on this method
      window-rules = [
        {
          matches = [
            {
              app-id = "^(librewolf)$";
              title = "^(Save File)$";
            }
            {
              app-id = "^(librewolf)$";
              title = "^(.*)(wants to save)$";
            }
          ];
          open-floating = true;
          opacity = 1.0;
          default-column-width.proportion = 0.4;
          default-window-height.proportion = 0.4;
        }
      ];
    };
  };

  home = {
    # remove the leftover native messaging hosts directory
    file = {
      ".librewolf/native-messaging-hosts".enable = lib.mkForce false;
      ".mozilla/native-messaging-hosts".enable = lib.mkForce false;
    };

    # set default browser
    sessionVariables = {
      DEFAULT_BROWSER = getExe pkgs.librewolf;
      BROWSER = getExe pkgs.librewolf;
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "x-scheme-handler/about" = "librewolf.desktop";
    "x-scheme-handler/unknown" = "librewolf.desktop";
  };

  stylix.targets.librewolf = {
    colorTheme.enable = true;
    firefoxGnomeTheme.enable = true;
    profileNames = [user];
  };

  custom.persist = {
    home.directories = [
      ".cache/librewolf"
      configPath
    ];
  };
}
