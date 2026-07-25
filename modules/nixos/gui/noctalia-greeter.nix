_: {
  flake.modules.nixos.gui = {config, ...}: {
    programs.noctalia-greeter = {
      enable = true;

      # Optional configuration
      greeter-args = "";

      settings = {
        output = {
          transforms = "DSI-1:270";
        };
        appearance = {
          scheme = "Synced";
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
