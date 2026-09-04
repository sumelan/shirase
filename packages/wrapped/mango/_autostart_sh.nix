{
  lib,
  pkgs,
  ...
}: let
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
    "${lib.getExe' pkgs.systemd "systemctl"} --user reset-failed"
    "${lib.getExe' pkgs.systemd "systemctl"} --user start mango-session.target"
  ];
in {
  exec-once =
    [
      "${lib.getExe' pkgs.dbus "dbus-update-activation-environment"} --systemd ${variables}"
    ]
    ++ extraCommands;
}
