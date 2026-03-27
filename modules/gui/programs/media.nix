_: {
  flake.modules.homeManager = {
    default = {pkgs, ...}: {
      home.packages = [
        pkgs.euphonica
        pkgs.grayjay
        pkgs.mpv
        pkgs.pear-desktop
      ];
      custom.fileSystem = {
        persist.home.directories = [
          ".cache/euphonica"
          ".local/share/Grayjay"
          ".local/state/mpv" # watch later
          ".config/YouTube Music"
        ];
      };
    };

    cd = {pkgs, ...}: {
      home.packages = [pkgs.cyanrip pkgs.picard];
    };

    bluray = {pkgs, ...}: {
      home.packages = [
        pkgs.handbrake
        pkgs.makemkv
        pkgs.vlc
      ];

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
      home.packages = [pkgs.foliate];

      custom.fileSystem = {
        persist.home.directories = [
          ".local/share/com.github.johnfactotum.Foliate"
        ];
        cache.home.directories = [
          ".cache/com.github.johnfactotum.Foliate"
        ];
      };
    };

    obs-studio = {pkgs, ...}: {
      home.packages = [pkgs.obs-studio];

      custom.fileSystem = {
        persist.home.directories = [
          ".config/obs-studio"
        ];
      };
    };
  };
}
