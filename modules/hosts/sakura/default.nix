{
  inputs,
  config,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos."hosts/sakura" = {
    config,
    pkgs,
    ...
  }: {
    imports = builtins.attrValues {
      inherit (flake.modules.nixos) default minisforum-um773se;
      inherit (flake.modules.nixos) gui;
      inherit (flake.modules.nixos) kdeconnect steam;
      inherit (flake.modules.nixos) hdds qmk trackpad;
      inherit (flake.modules.nixos) audiobookshelf sops-nix syncoid syncthing;
      inherit (flake.modules.nixos) hjem-extended hjem-bluray hjem-cd;
    };

    networking.hostId = "b5e8f0be";

    environment.variables = {
      GITHUB_TOKEN = config.sops.secrets."github/sakura-token".path;
    };

    services.hazkey.server.package = inputs.nix-hazkey.packages.${pkgs.stdenv.hostPlatform.system}.hazkey-server.override {enableVulkan = true;};

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

      programs = {
        btop.rocmSupport = true;
        niri = {xwayland = true;};
      };
    };
  };
}
