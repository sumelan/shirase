{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    krita.enable = mkEnableOption "krita";
  };

  config = lib.mkIf config.custom.krita.enable {
    home.packages = with pkgs; [ krita ];

    programs.niri.settings.window-rules = [
      {
        matches = [ { app-id = "^(krita)$"; } ];
        open-floating = true;
        open-on-output = builtins.toString config.lib.monitors.otherMonitorsNames;
        border.enable = false;
        shadow.enable = false;
        opacity = 1.0;
      }
    ];
    # py-menu plugins
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
        files = [
          ".config/kritadisplayrc"
          ".config/kritarc"
          ".config/kritashortcutsrc"
        ];
        directories = [
          ".local/share/krita"
        ];
      };
    };
  };
}
