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
          theme = "Capitaine Cursors (Nord)";
          size = 38;
          path = "${pkgs.capitaine-cursors-themed}/share/icons/Capitaine Cursors (Nord)";
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
