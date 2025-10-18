{
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit
    (lib)
    getExe
    mkForce
    ;
  zen-browser = inputs.zen-browser.packages.${pkgs.system}.twilight;
in {
  programs = {
    zen-browser = {
      enable = true;
      policies = let
        mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
          installation_mode = "force_installed";
        });
      in {
        ExtensionSettings = mkExtensionSettings {
          "uBlock0@raymondhill.net" = "ublock-origin";
          "sponsorBlocker@ajay.app" = "sponsorblock";
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
          "addon@darkreader.org" = "darkreader";
          "search@kagi.com" = "kagi-search";
          "{f2bcd203-646c-4f72-8da5-092a671277cc}" = "eldritch";
        };

        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
    };

    niri.settings.binds = {
      "Mod+B" = {
        action.spawn = ["zen"];
        hotkey-overlay.title = ''<span foreground="#37f499">[Application]</span> Zen Browser'';
      };
    };
  };

  # set default browser
  home.sessionVariables = {
    DEFAULT_BROWSER = getExe zen-browser;
    BROWSER = getExe zen-browser;
  };

  xdg.mimeApps = let
    value = zen-browser.meta.desktopFileName;

    associations = builtins.listToAttrs (map (name: {
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
    associations.added = associations;
    defaultApplications = associations;
  };

  home.file.".mozilla/extensions".enable = mkForce false;

  custom.persist = {
    home.directories = [
      ".zen"
    ];
  };
}
