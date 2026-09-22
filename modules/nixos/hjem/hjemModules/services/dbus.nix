{lib, ...}: let
  inherit (lib) mkOption mkIf;
  inherit (lib.types) listOf package;
in {
  flake.custom.hjemModules.dbus = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.dbus;
  in {
    options.rum = {
      dbus.packages = mkOption {
        type = listOf package;
        default = [];
        description = ''
          Packages whose D-Bus configuration files should be included in
          the configuration of the D-Bus session-wide message bus. Specifically,
          files in «pkg»/share/dbus-1/services will be included in the user's
          $XDG_DATA_HOME/dbus-1/services directory.
        '';
      };
    };

    config = {
      xdg.data.files = mkIf (cfg.packages != []) {
        "dbus-1/services" = {
          source = pkgs.symlinkJoin {
            name = "user-dbus-services";
            paths = cfg.packages;
            stripPrefix = "/share/dbus-1/services";
          };
        };
      };
    };
  };
}
