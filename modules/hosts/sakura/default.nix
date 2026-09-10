{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos."hosts/sakura" = {pkgs, ...}: {
    imports = builtins.attrValues {
      inherit (config.flake.modules.nixos) minisforum-um773se;
      inherit (config.flake.modules.nixos) gui;
      inherit (config.flake.modules.nixos) kdeconnect;
      # inherit (config.flake.modules.nixos) steam;
      inherit (config.flake.modules.nixos) hdds qmk trackpad;
      inherit (config.flake.modules.nixos) audiobookshelf sops-nix syncoid syncthing sshConfig;
      inherit (config.flake.modules.nixos) hjem-extended;
    };

    networking.hostId = "b5e8f0be";

    services = {
      hazkey.server = {
        package = inputs.nix-hazkey.packages.${pkgs.stdenv.hostPlatform.system}.hazkey-server.override {
          enableVulkan = true;
        };
      };
    };

    custom = {
      hardware = {
        hdds = {
          westernDigital = true;
          ironWolf = true;
        };
      };

      programs.btop.rocmSupport = true;
    };
  };
}
