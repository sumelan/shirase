{
  inputs,
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit (lib) getExe mkForce concatStringsSep;
  inherit (lib.custom.colors) cyan_bright;
  inherit (lib.custom.niri) spawn hotkey;
  configPath = ".config/.librewolf";
in {
  programs = {
    librewolf = {
      enable = true;
      languagePacks = ["en-US" "ja-JP"];
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
        search = {
          force = true;
          default = "kagi";
          # ddg means DuckDuckGo
          order = ["kagi" "ddg" "google"];
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              icon = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@nw"];
            };
            "kagi" = {
              urls = [{template = "https://kagi.com/search?q={searchTerms}";}];
              icon = "https://kagi.com/favicon.ico";
              definedAliases = ["@kagi"];
            };
            "bing".metaData.hidden = true;
            # builtin engines only support specifying one additional alias
            "google".metaData.alias = "@g";
          };
        };
        bookmarks = {};
        # avaiable list:
        # https://gitlab.com/rycee/nur-expressions?dir=pkgs/firefox-addons
        extensions.packages = builtins.attrValues {
          inherit
            (inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system})
            bitwarden
            darkreader
            kagi-privacy-pass
            kagi-search
            # kagi-translate
            kristofferhagen-nord-theme
            sponsorblock
            ublock-origin
            youtube-auto-hd-fps
            youtube-no-translation
            youtube-shorts-block
            ;
        };
        settings = {
          # enable extensions immediately upon new install
          "extensions.autoDisableScopes" = 0;
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
          action.spawn = spawn "librewolf";
          hotkey-overlay.title = hotkey {
            color = cyan_bright;
            name = "  Librewolf";
            text = "Web Browser";
          };
        };
      };

      # NOTE: bitwarden window cannot be floated on this method
      # https://github.com/YaLTeR/niri/discussions/1599
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
          default-column-width.proportion = 0.4;
          default-window-height.proportion = 0.4;
          opacity = 1.0;
        }
      ];
    };
  };

  home = {
    file = {
      # remove the leftover native messaging hosts directory
      ".librewolf/native-messaging-hosts".enable = mkForce false;
      ".mozilla/native-messaging-hosts".enable = mkForce false;
    };
    sessionVariables = {
      # set default browser
      DEFAULT_BROWSER = getExe config.programs.librewolf.package;
      BROWSER = getExe config.programs.librewolf.package;
    };
  };

  xdg.mimeApps = let
    value = "librewolf.desktop";
    htmlAssociations = builtins.listToAttrs (map (name: {
        inherit name value;
      }) [
        "application/x-extension-shtml"
        "application/x-extension-xhtml"
        "application/x-extension-html"
        "application/x-extension-xht"
        "application/x-extension-htm"
        "x-scheme-handler/unknown"
        "x-scheme-handler/mailto"
        "x-scheme-handler/chrome"
        "x-scheme-handler/about"
        "x-scheme-handler/https"
        "x-scheme-handler/http"
        "application/xhtml+xml"
        "application/json"
        "text/plain"
        "text/html"
      ]);
  in {
    associations.added = htmlAssociations;
    defaultApplications = htmlAssociations;
  };

  custom.persist = {
    home.directories = [
      ".cache/librewolf"
      configPath
    ];
  };
}
