{
  lib,
  pkgs,
  ...
}:
let
  webApps = [
    {
      name = "qobuz";
      desktopName = "Qobuz Web Player";
      url = "https://play.qobuz.com";
      icon = ./icons/qobuz.svg;
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
        "Player"
      ];
    }
  ];
in
{
  home.packages = builtins.map (
    app:
    pkgs.makeDesktopItem {
      type = "Application";
      name = app.name;
      desktopName = app.desktopName;
      exec = "${lib.getExe pkgs.firefox} --profile .mozilla/firefox/${app.name} --name ${app.name}-WebApp ${app.url}";
      terminal = false;
      icon = app.icon;
      categories = app.categories;
    }
  ) webApps;

  home.file = builtins.listToAttrs (
    builtins.concatMap (
      app:
      let
        user = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("browser.cache.disk.enable", false);
          user_pref("browser.cache.memory.enable", true);
          user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);
          user_pref("browser.urlbar.autocomplete.enabled", false);
          user_pref("places.history.enabled", false);
          user_pref("geo.enabled", false);
          user_pref("browser.crashReports.enabled", false);
          user_pref("dom.push.enabled", false);
          user_pref("dom.webnotifications.enabled", false);
          user_pref("extensions.enabled", false);
          user_pref("extensions.pocket.enabled", false);
          user_pref("extensions.formautofill.enabled", false);
          user_pref("app.update.auto", false);
          user_pref("app.update.enabled", false);
          user_pref("app.update.silent", true);
          user_pref("signon.rememberSignons", false);
          user_pref("privacy.sanitize.sanitizeOnShutdown", true);
          user_pref("privacy.sanitize.timeSpan", 0);
          user_pref("privacy.clearOnShutdown.cookies", false);
          user_pref("privacy.clearOnShutdown.history", true);
          user_pref("privacy.clearOnShutdown.cache", true);
          user_pref("privacy.clearOnShutdown.sessions", true);
          user_pref("privacy.clearOnShutdown.offlineApps", true);
          user_pref("privacy.clearOnShutdown.formdata", true);
        '';
        userChrome = ''
          #TabsToolbar, #identity-box, #tabbrowser-tabs, #TabsToolbar { display: none !important; }
          #nav-bar { visibility: collapse !important; }
        '';
      in
      [
        {
          name = ".mozilla/firefox/${app.name}/user.js";
          value = {
            text = user;
          };
        }
        {
          name = ".mozilla/firefox/${app.name}/chrome/userChrome.css";
          value = {
            text = userChrome;
          };
        }
      ]
    ) webApps
  );

  home.activation.cleanupFirefoxProfiles =
    let
      appNames = builtins.map (app: app.name) webApps;
      keepDirs = [
        "profiles.ini"
        "Crash Reports"
        "Pending Pings"
        "default"
        "default-backup"
      ] ++ appNames;
    in
    ''
      firefoxProfilesDir=".mozilla/firefox"

      keepDirsStr="${lib.strings.concatStringsSep " " keepDirs}"

      for profile in "$firefoxProfilesDir"/*; do
        profileName=$(basename "$profile")

        if [[ ! " $keepDirsStr " =~ " $profileName " ]]; then
          rm -rf "$profile"
        fi
      done
    '';
}
