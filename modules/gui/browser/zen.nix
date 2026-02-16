{
  inputs,
  lib,
  ...
}: let
  inherit (lib) concatLines mapAttrsToList getExe;
  inherit (lib.strings) toJSON;
  inherit (builtins) listToAttrs;
in {
  flake.modules.homeManager.default = {
    config,
    pkgs,
    ...
  }: let
    extension = shortId: guid: {
      name = guid;
      value = {
        install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
        installation_mode = "force_installed";
      };
    };

    prefs = {
      # Check these out at about:config
      "extensions.autoDisableScopes" = 0;
      "extensions.pocket.enabled" = false;
      "font.name.serif.x-western" = config.gtk.font.name;
      # ...
    };

    extensions = [
      # To add additional extensions, find it on addons.mozilla.org, find
      # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
      # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
      (extension "darkreader" "addon@darkreader.org")
      (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
      (extension "kagi-privacy-pass" "privacypass@kagi.com")
      (extension "kagi-translate" "{bd6be57d-91d7-41d2-b61d-3ba20f7942e5}")
      (extension "sponsorblock" "sponsorBlocker@ajay.app")
      (extension "ublock-origin" "uBlock0@raymondhill.net")
      (extension "youtube-auto-hd-fps" "avi6106@gmail.com")
      (extension "youtube-no-translation" "{9a3104a2-02c2-464c-b069-82344e5ed4ec}")
      (extension "youtube-shorts-block" "{34daeb50-c2d2-4f14-886a-7160b24d66a4}")
      # ...
    ];

    zen =
      pkgs.wrapFirefox
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
      {
        extraPrefs = concatLines (
          mapAttrsToList (
            name: value: ''lockPref(${toJSON name}, ${toJSON value});''
          )
          prefs
        );

        extraPolicies = {
          DisableTelemetry = true;
          ExtensionSettings = listToAttrs extensions;
          RequestedLocales = "ja,en-US";
          SearchEngines = {
            Default = "ddg";
            Add = [
              {
                Name = "nixpkgs packages";
                URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@np";
              }
              {
                Name = "NixOS options";
                URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@no";
              }
              {
                Name = "NixOS Wiki";
                URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@nw";
              }
              {
                Name = "noogle";
                URLTemplate = "https://noogle.dev/q?term={searchTerms}";
                IconURL = "https://noogle.dev/favicon.ico";
                Alias = "@ng";
              }
              {
                Name = "Kagi";
                URLTemplate = "https://kagi.com/search?q={searchTerms}";
                IconURL = "https://kagi.com/favicon.ico";
                Alias = "@kg";
              }
            ];
            Remove = ["Google" "Bing"];
          };
        };
      };
  in {
    home = {
      packages = [zen];
      sessionVariables = {
        # set default browser
        DEFAULT_BROWSER = getExe zen;
        BROWSER = getExe zen;
      };
    };

    xdg.mimeApps = let
      value = "zen.desktop";
      associations = listToAttrs (map (name: {
          inherit name value;
        }) [
          "x-scheme-handler/unknown"
          "x-scheme-handler/about"
          "x-scheme-handler/https"
          "x-scheme-handler/http"
          "text/html"
        ]);
    in {
      associations.added = associations;
      defaultApplications = associations;
    };

    custom = {
      persist.home.directories = [
        ".config/zen"
      ];
      cache.home.directories = [
        ".cache/zen"
      ];
    };
  };
}
