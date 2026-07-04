{inputs, ...}: {
  flake.modules.nixos.gui = {pkgs, ...}: {
    programs.noctalia-greeter = {
      enable = true;
      package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;

      # Optional configuration
      greeter-args = "";

      settings = {
        appearance = {
          scheme = "Synced";
        };
        cursor = {
          theme = "Capitaine Cursors (Nord)";
          size = 38;
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
