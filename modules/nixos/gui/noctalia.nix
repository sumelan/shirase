_: {
  flake.modules.nixos.gui = {
    config,
    user,
    ...
  }: let
    cfg = config.services.displayManager.noctalia-greeter;
  in {
    programs.noctalia = {
      enable = true;
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
          default = user;
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
    };

    custom.fileSystem = {
      cache.root.directories = [
        "/var/lib/noctalia-greeter"
      ];
    };
  };
}
