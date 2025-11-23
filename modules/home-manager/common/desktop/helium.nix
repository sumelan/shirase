{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
  inherit (lib.custom.colors) blue0;
  inherit (lib.custom.niri) spawn hotkey;
in {
  programs = {
    chromium = {
      enable = true;
      package = pkgs.custom.helium;
    };

    niri.settings.binds = {
      "Mod+B" = {
        action.spawn = spawn "helium";
        hotkey-overlay.title = hotkey {
          color = blue0;
          name = "  Helium";
          text = "Web Browser";
        };
      };
    };
  };

  # set default browser
  home.sessionVariables = {
    DEFAULT_BROWSER = getExe config.programs.chromium.package;
    BROWSER = getExe config.programs.chromium.package;
  };

  xdg.mimeApps = let
    value = "helium.desktop";
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

    imgAssociations = builtins.listToAttrs (map (name: {
        inherit name value;
      }) [
        "image/jpeg"
        "image/gif"
        "image/webp"
        "image/png"
      ]);
  in {
    # add `helium.desktop` in html mimetypes and set as a default app
    associations.added = htmlAssociations;
    defaultApplications = htmlAssociations;
    # remove `helium.desktop` from image mimetypes
    associations.removed = imgAssociations;
  };

  custom.persist = {
    home.directories = [
      ".cache/net.imput.helium"
      ".config/net.imput.helium"
    ];
  };
}
