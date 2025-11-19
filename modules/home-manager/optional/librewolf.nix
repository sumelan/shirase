{
  inputs,
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkForce
    concatStringsSep
    ;
  configPath = ".config/.librewolf";
in {
  options.custom = {
    librewolf.enable = mkEnableOption "Librewolf";
  };

  config = mkIf config.custom.librewolf.enable {
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
          search = {
            force = true;
            default = "kagi";
            # ddg = DuckDuckGo
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
          extensions.packages = builtins.attrValues {
            inherit
              (inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system})
              bitwarden
              darkreader
              sponsorblock
              ublock-origin
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
            default-column-width.proportion = 0.4;
            default-window-height.proportion = 0.4;
            opacity = 1.0;
          }
        ];
      };
    };

    # remove the leftover native messaging hosts directory
    home.file = {
      ".librewolf/native-messaging-hosts".enable = mkForce false;
      ".mozilla/native-messaging-hosts".enable = mkForce false;
    };

    custom.persist = {
      home.directories = [
        ".cache/librewolf"
        configPath
      ];
    };
  };
}
