{config, ...}: {
  flake.modules.nixos = {
    hjem-extended = _: {
      imports = builtins.attrValues {
        inherit (config.flake.modules.nixos) obs-studio zen zed-editor;
      };
    };

    hjem-cd = {pkgs, ...}: {
      hj.packages = [
        pkgs.cyanrip
        pkgs.picard
      ];
    };

    hjem-bluray = {pkgs, ...}: {
      hj = {
        packages = [
          pkgs.handbrake
          pkgs.makemkv
          pkgs.vlc
        ];

        xdg.mime-apps = let
          handbrake = "fr.handbrake.ghb.desktop";
          vlc = "vlc.desktop";
          associations = builtins.listToAttrs (map (name: {
              inherit name;
              value = [handbrake vlc];
            })
            [
              "audio/ogg"
              "audio/flac"
              "video/mp4"
            ]);
        in {
          removed-associations = associations;
        };
      };

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
  };
}
