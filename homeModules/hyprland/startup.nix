{
  config,
  lib,
  pkgs,
  user,
  ...
}:
lib.mkIf config.custom.hyprland.enable {
  custom.autologinCommand = "uwsm start hyprland-uwsm.desktop";

  # start hyprland
  programs.bash.profileExtra = ''
    if [ "$(tty)" = "/dev/tty1" ]; then
      if uwsm check may-start; then
        ${config.custom.autologinCommand}
      fi
    fi
  '';

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      # init ipc listener
      "hypr-ipc &"

      # fix gparted "cannot open display: :0" error
      "${lib.getExe pkgs.xorg.xhost} +local:${user}"
      # fix Authorization required, but no authorization protocol specified error
      # "${lib.getExe pkgs.xorg.xhost} si:localuser:root"

      # stop fucking with my cursors
      "hyprctl setcursor ${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}"
    ];
  };

  # start swww and wallpaper via systemd to minimize reloads
  systemd.user.services =
    let
      graphicalTarget = config.wayland.systemd.target;
    in
    {
      swww = {
        Install.WantedBy = [ graphicalTarget ];
        Unit = {
          Description = "Wayland wallpaper daemon";
          After = [ graphicalTarget ];
          PartOf = [ graphicalTarget ];
        };
        Service = {
          ExecStart = lib.getExe' pkgs.swww "swww-daemon";
          Restart = "on-failure";
        };
      };
    };
}
