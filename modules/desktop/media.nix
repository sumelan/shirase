_: {
  flake.modules.homeManager = {
    default = {pkgs, ...}: {
      home.packages = [pkgs.mpv];

      custom.persist.home.directories = [
        ".local/state/mpv" # watch later
      ];
    };

    obs-studio = _: {
      programs.obs-studio.enable = true;
      custom.persist.home.directories = [".config/obs-studio"];
    };

    vlc = {pkgs, ...}: {
      home.packages = builtins.attrValues {
        inherit (pkgs) vlc handbrake;
      };

      custom.persist.home = {
        files = [
          ".config/aacs/KEYDB.cfg"
        ];
        directories = [
          ".config/vlc"
        ];
      };
    };
  };
}
