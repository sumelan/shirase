{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos = {
    hjem-extended = {pkgs, ...}: let
      inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) zeditor zedConfig;
    in {
      imports = builtins.attrValues {
        inherit (flake.modules.nixos) zen;
      };

      hj = {
        packages = [
          pkgs.obs-studio
          zeditor
        ];

        xdg.config.files."zed/settings.json".source = zedConfig;
      };

      custom.fileSystem = {
        persist.home.directories = [
          ".config/obs-studio"
        ];
      };
    };

    hjem-cd = {pkgs, ...}: {
      hj.packages = [
        pkgs.cyanrip
        pkgs.picard
      ];
    };

    hjem-bluray = {pkgs, ...}: {
      hj.packages = [
        pkgs.handbrake
        pkgs.makemkv
        pkgs.vlc
      ];

      # find usb bluray drive
      # https://discourse.nixos.org/t/makemkv-cant-find-my-usb-blu-ray-drive/23714
      boot.kernelModules = ["sg"];

      custom.fileSystem = {
        persist.home = {
          files = [
            ".config/aacs/KEYDB.cfg"
          ];
          directories = [
            ".config/ghb" # handbrake
            ".config/vlc"
            ".MakeMKV"
          ];
        };
      };
    };

    hjem-drawing = _: {
      imports = with flake.modules.nixos; [
        pen-tablet
        krita
      ];
    };
  };
}
