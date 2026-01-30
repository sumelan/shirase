_: {
  flake.modules.homeManager = {
    default = {pkgs, ...}: {
      home.packages = builtins.attrValues {
        inherit
          (pkgs)
          cyanrip
          euphonica
          mpv
          picard
          ;
      };

      custom.persist.home.directories = [
        ".cache/euphonica"
        ".local/state/mpv" # watch later
      ];
    };

    foliate = {pkgs, ...}: {
      home.packages = [pkgs.foliate];

      custom = {
        persist.home.directories = [
          ".local/share/com.github.johnfactotum.Foliate"
        ];
        cache.home.directories = [
          ".cache/com.github.johnfactotum.Foliate"
        ];
      };
    };

    obs-studio = _: {
      programs.obs-studio.enable = true;
      custom.persist.home.directories = [".config/obs-studio"];
    };

    vlc = {pkgs, ...}: {
      home.packages = [pkgs.vlc];

      custom.persist.home = {
        files = [
          ".config/aacs/KEYDB.cfg"
        ];
        directories = [
          ".config/vlc"
        ];
      };
    };

    pear-desktop = {pkgs, ...}: {
      home.packages = [pkgs.pear-desktop];

      custom.persist.home.directories = [
        ".config/YouTube Music"
      ];
    };
  };
}
