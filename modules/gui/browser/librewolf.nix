{
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkForce concatStringsSep;
in {
  flake.modules.homeManager.librewolf = {
    config,
    pkgs,
    user,
    ...
  }: let
    inherit (config.xdg) configHome;
    configPath = ".config/.librewolf";
  in {
    programs.librewolf = {
      enable = true;
      languagePacks = ["en-US" "ja-JP"];
      package = pkgs.librewolf.overrideAttrs (o: {
        # launch librewolf with user profile
        buildCommand =
          o.buildCommand
          + ''
            wrapProgram "$out/bin/librewolf" \
              --set 'HOME' '${configHome}' \
              --append-flags "${
              concatStringsSep " " [
                "--name librewolf"
                # load librewolf profile with same name as user
                "--profile /home/${user}/${configPath}/${user}"
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
              urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
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

    home.file = {
      # remove the leftover native messaging hosts directory
      ".librewolf/native-messaging-hosts".enable = mkForce false;
      ".mozilla/native-messaging-hosts".enable = mkForce false;
    };

    custom.persist.home.directories = [
      ".cache/librewolf"
      configPath
    ];
  };
}
