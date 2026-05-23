{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos."hosts/acer" = {pkgs, ...}: {
    imports = builtins.attrValues {
      inherit (flake.modules.nixos) default acer-al14;
      inherit (flake.modules.nixos) gui;
      inherit (flake.modules.nixos) kdeconnect;
      inherit (flake.modules.nixos) sshConfig;
    };

    networking.hostId = "22fe2870";

    custom = {
      hardware.monitors = {
        "eDP-1" = {
          isMain = true;
          scale = 1.0;
          mode = {
            width = 1920;
            height = 1200;
            refresh = 60.0;
          };
          position = {
            x = 0;
            y = 0;
          };
          rotation = 0;
        };
      };

      # hinted font: for lower or equal than 1080p
      fonts.packages = [pkgs.maple-mono.NF];
    };
  };
}
