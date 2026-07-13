_: {
  flake.modules.nixos.gui = {pkgs, ...}: {
    programs.noctalia-greeter = {
      enable = true;

      # Optional configuration
      greeter-args = "";

      settings = {
        appearance = {
          scheme = "Synced";
        };
        cursor = {
          theme = "Bibata-Modern-Ice";
          size = 38;
          path = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice";
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
