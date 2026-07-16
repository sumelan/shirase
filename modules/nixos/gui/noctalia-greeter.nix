_: {
  flake.modules.nixos.gui = {pkgs, ...}: {
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
          theme = "Bibata-Modern-Ice";
          size = 18;
          package = pkgs.bibata-cursors;
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
