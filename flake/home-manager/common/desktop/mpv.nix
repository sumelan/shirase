{pkgs, ...}: {
  home.packages = [pkgs.mpv];

  custom.persist = {
    home.directories = [
      ".local/state/mpv" # watch later
    ];
  };
}
