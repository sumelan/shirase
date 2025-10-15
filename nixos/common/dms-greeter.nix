{
  lib,
  config,
  user,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.custom = {
    dms-greeter.enable =
      mkEnableOption "dms-greeter"
      // {
        default = true;
      };
  };

  config = mkIf config.custom.dms-greeter.enable {
    # tty autologin
    services.getty.autologinUser = user;

    programs.dankMaterialShell.greeter = {
      enable = true;
      compositor.name = "niri";
      # optionally copyies that users DMS settings (and wallpaper if set) to the greeters data directory
      # as root before greeter starts
      configHome = config.hm.home.homeDirectory;
    };

    custom.persist = {
      root.directories = [
        # greeter cache
        "/var/lib/dmsgreeter"
      ];
    };
  };
}
