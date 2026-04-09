_: {
  flake.modules.nixos = {
    gui = {pkgs, ...}: {
      hj.packages = [
        pkgs.grayjay
        pkgs.mpv
        pkgs.pear-desktop
      ];

      custom.fileSystem = {
        persist.home.directories = [
          ".local/share/Grayjay"
          ".local/state/mpv" # watch later
          ".config/YouTube Music"
        ];
      };
    };

    cd = {pkgs, ...}: {
      hj.packages = [
        pkgs.cyanrip
        pkgs.picard
      ];
    };

    bluray = {pkgs, ...}: {
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
            # handbrake
            ".config/ghb"
            ".config/vlc"
            ".MakeMKV"
          ];
        };
      };
    };

    ebook = {pkgs, ...}: {
      hj.packages = [
        pkgs.foliate
      ];

      custom.fileSystem = {
        persist.home.directories = [
          ".local/share/com.github.johnfactotum.Foliate"
        ];
        cache.home.directories = [
          ".cache/com.github.johnfactotum.Foliate"
        ];
      };
    };

    obs = {pkgs, ...}: {
      hj.packages = [
        pkgs.obs-studio
      ];

      custom.fileSystem = {
        persist.home.directories = [
          ".config/obs-studio"
        ];
      };
    };
  };
}
