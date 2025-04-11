{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    krita.enable = mkEnableOption "krita";
  };

  config = lib.mkIf config.custom.krita.enable {
    home.packages = [ pkgs.krita ];

    programs.niri.settings.window-rules = [
      {
        matches = [ { app-id = "^(krita)$"; } ];
        open-maximized = true;
        open-on-output = "DP-1";
        opacity = 1.0;
      }
      {
        matches = [
          {
            app-id = "^(krita)$";
            title = "^(.* Krita)$";
          }
        ];
        open-floating = true;
      }
    ];
    # python plugins
    home.file.".local/share/krita/pykrita" = {
      source = pkgs.fetchFromGitHub {
        owner = "wojtryb";
        repo = "Shortcut-Composer";
        rev = "v1.5.4";
        hash = "sha256-XQuP0GeCcOIgbVatIynC4K9obdM8teeK5skq/8tF7sc=";
      };
      recursive = true;
    };

    custom.persist = {
      home = {
        directories = [
          ".local/share/krita"
        ];
        files = [
          ".config/kritadisplayrc"
          ".config/kritarc"
          ".config/kritashortcutsrc"
        ];
      };
    };
  };
}
