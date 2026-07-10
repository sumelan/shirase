{config, ...}: {
  flake.modules.nixos."hosts/sakura" = {pkgs, ...}: {
    imports = builtins.attrValues {
      inherit (config.flake.modules.nixos) default minisforum-um773se;
      inherit (config.flake.modules.nixos) gui;
      inherit (config.flake.modules.nixos) kdeconnect steam;
      inherit (config.flake.modules.nixos) hdds qmk trackpad;
      inherit (config.flake.modules.nixos) audiobookshelf sops-nix syncoid syncthing;
      inherit (config.flake.modules.nixos) hjem-extended hjem-bluray hjem-cd;
    };

    networking.hostId = "b5e8f0be";

    custom = {
      hardware = {
        monitors = {
          "HDMI-A-1" = {
            isMain = true;
            scale = 1.5;
            mode = {
              width = 3840;
              height = 2160;
              refresh = 60.0;
            };
            position = {
              x = 0;
              y = 0;
            };
            rotation = 0;
          };
        };

        hdds = {
          westernDigital = true;
          ironWolf = true;
        };
      };

      # unhinted font: for high resolution screen
      fonts.packages = [pkgs.maple-mono.NF-unhinted];

      programs = {
        btop.rocmSupport = true;
        niri = {xwayland = true;};
      };
    };
  };
}
