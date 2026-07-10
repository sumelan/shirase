{config, ...}: {
  flake.modules.nixos."hosts/minibookx" = {pkgs, ...}: {
    imports = builtins.attrValues {
      inherit (config.flake.modules.nixos) default chuwi-minibook-x;
      inherit (config.flake.modules.nixos) gui;
      inherit (config.flake.modules.nixos) kdeconnect;
      inherit (config.flake.modules.nixos) sops-nix syncthing sshConfig;
    };

    networking.hostId = "56895d2b";

    custom = {
      hardware.monitors = {
        "DSI-1" = {
          isMain = true;
          scale = 1.0;
          mode = {
            width = 1200;
            height = 1920;
            refresh = 90.000;
          };
          position = {
            x = 0;
            y = 0;
          };
          rotation = 270;
        };
      };

      # hinted font: for lower or equal than 1080p
      fonts.packages = [pkgs.maple-mono.NF];
    };
  };
}
