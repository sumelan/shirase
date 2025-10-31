{
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

        policies = {
          Extensions = {
            Install = [
              "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/"
              "https://addons.mozilla.org/firefox/downloads/latest/darkreader/"
              "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/"
              "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/"
            ];
            # extension IOs can be obtained after installation by going to about:support
            Locked = [
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" # bitwarden
              "addon@darkreader.org"
              "sponsorBlocker@ajay.app"
              "uBlock0@raymondhill.net"
            ];
            ExtensionSettings = {
              # bitwarden
              "{446900e4-71c2-419f-a6a7-df9c091e268b}".private_browsing = true;
              "addon@darkreader.org".private_browsing = true;
              "sponsorBlocker@ajay.app".private_browsing = true;
              "uBlock0@raymondhill.net".private_browsing = true;
            };
          };
        };

        profiles.${user} = {
          # Whether to override all previous librewolf settings.
          # This is required when using 'settings'.
          extensions.force = true;
          settings = {
            "extensions.autoDisableScopes" = 0; # enable extensions immediately upon new install
            "privacy.clearOnShutdown_v2.cache" = false;
            "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
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
  };
}
