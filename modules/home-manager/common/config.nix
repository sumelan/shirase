{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      brightnessctl
      cliphist
      libnotify
      playerctl
      wl-clipboard
      ;
  };
}
