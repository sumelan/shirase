{pkgs, ...}: let
  inherit (pkgs) lib;
  # Environment variables imported into the systemd and D-Bus user environment.
  variables =
    [
      "DISPLAY"
      "WAYLAND_DISPLAY"
      "XDG_CURRENT_DESKTOP"
      "XDG_SESSION_TYPE"
      "NIXOS_OZONE_WL"
      "XCURSOR_THEME"
      "XCURSOR_SIZE"
    ] # example: [ "--all" ]
    |> lib.concatStringsSep " ";

  # Extra commands to run after D-Bus activation.
  extraCommands = [
    "brightnessctl set 10%"
  ];
in {
  exec_once =
    [
      "dbus-update-activation-environment --systemd ${variables}"
      "systemctl --user reset-failed"
      "systemctl --user start mango-session.target"
    ]
    ++ extraCommands;
}
