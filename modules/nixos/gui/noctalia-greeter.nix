_: {
  flake.modules.nixos.gui = {
    config,
    user,
    ...
  }: {
    programs.noctalia-greeter = {
      enable = true;

      # Optional configuration
      greeter-args = "";

      settings = {
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
        cursor = {
          theme = config.custom.gtk.cursor.name;
          size = 28;
          inherit (config.custom.gtk.cursor) package;
        };
        keyboard = {
          layout = "us";
        };
      };
    };

    custom.fileSystem = {
      cache.root.directories = [
        "/var/lib/noctalia-greeter"
      ];
    };
  };
}
