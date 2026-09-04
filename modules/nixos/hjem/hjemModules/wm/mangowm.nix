{lib, ...}: let
  inherit
    (lib)
    mkIf
    mkPackageOption
    mkEnableOption
    ;
in {
  flake.custom.hjemModules.mangowm = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.wayland.windowManager.mango;
  in {
    options.rum = {
      wayland.windowManager.mango = {
        enable = mkEnableOption "Whether to enable mangowm, a Wayland compositor based on dwl.";

        package = mkPackageOption pkgs "mango" {};

        systemd = {
          enable = mkEnableOption ''
            Whether to enable {file}`mango-session.target` on mango startup.
            This links to {file}`graphical-session.target`.
            Some important environment variables will be imported to systemd and dbus user environment before reaching the target,
            including
                * {env}`DISPLAY`
                * {env}`WAYLAND_DISPLAY`
                * {env}`XDG_CURRENT_DESKTOP`
                * {env}`XDG_SESSION_TYPE`
                * {env}`NIXOS_OZONE_WL`
            You can extend this list using the `systemd.variables` option.
          '';

          xdgAutostart = mkEnableOption ''
            autostart of applications using {manpage}`systemd-xdg-autostart-generator(8)`
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      packages = [cfg.package];

      systemd.targets.mango-session = mkIf cfg.systemd.enable {
        description = "mango compositor session";
        documentation = ["man:systemd.special(7)"];
        bindsTo = ["graphical-session.target"];
        wants = ["graphical-session-pre.target"] ++ lib.optional cfg.systemd.xdgAutostart "xdg-desktop-autostart.target";
        after = ["graphical-session-pre.target"];
        before = lib.optional cfg.systemd.xdgAutostart "xdg-desktop-autostart.target";
      };
    };
  };
}
