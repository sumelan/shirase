{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    ;
in {
  programs = {
    chromium = {
      enable = true;
      package = pkgs.custom.helium;
    };

    niri.settings.binds = {
      "Mod+B" = {
        action.spawn = ["helium"];
        hotkey-overlay.title = ''<span foreground="${config.lib.stylix.colors.withHashtag.base0B}">[Application]</span> Helium'';
      };
    };
  };

  # set default browser
  home.sessionVariables = {
    DEFAULT_BROWSER = getExe config.programs.chromium.package;
    BROWSER = getExe config.programs.chromium.package;
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "helium.desktop";
    "x-scheme-handler/http" = "helium.desktop";
    "x-scheme-handler/https" = "helium.desktop";
    "x-scheme-handler/about" = "helium.desktop";
    "x-scheme-handler/unknown" = "helium.desktop";
  };

  custom.persist = {
    home.directories = [
      ".cache/net.imput.helium"
      ".config/net.imput.helium"
    ];
  };
}
