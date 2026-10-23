{
  self,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.displayManager.noctalia-greeter;
in {
  programs.noctalia = {
    enable = true;
    package = self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia;
    systemd.enable = true;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;

    settings = {
      cursor = {
        size = 28;
        theme = cfg.cursorTheme.name;
      };
      user = {
        default = "sumelan";
      };
      output = {
        transforms = "DSI-1:270";
      };
      appearance = {
        scheme = "Synced";
        hide_logo = true;
        font_family = config.custom.fonts.regular;
      };
      keyboard = {
        layout = "us";
      };
    };

    cursorTheme = {
      inherit (config.custom.gtk.cursor) name package;
    };

    passwordlessSyncUsers = ["sumelan"];
  };

  custom.fileSystem = {
    cache.root.directories = [
      {
        directory = "/var/lib/noctalia-greeter";
        user = "greeter";
        group = "greeter";
        mode = "0750";
      }
    ];
  };
}
