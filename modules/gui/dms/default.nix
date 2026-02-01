{lib, ...}: let
  inherit (lib) mkForce;
in {
  flake.modules.homeManager.default = {
    config,
    user,
    ...
  }: let
    dmsConf = "${config.xdg.configHome}/niri/dms";
  in {
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;
    };

    systemd.user = {
      tmpfiles.rules = [
        # create dms kdl files if not existed
        "f ${dmsConf}/alttab.kdl 644 ${user} users - -"
        "f ${dmsConf}/binds.kdl 644 ${user} users - -"
        "f ${dmsConf}/colors.kdl 644 ${user} users - -"
        "f ${dmsConf}/layout.kdl 644 ${user} users - -"
        "f ${dmsConf}/outputs.kdl 644 ${user} users - -"
        "f ${dmsConf}/windowrules.kdl 644 ${user} user - -"
        "f ${dmsConf}/wpblur.kdl 644 ${user} users - -"
        "f ${dmsConf}/cursor.kdl 644 ${user} users - -"
      ];
      # override service config flake provide
      services.dms.Service.Restart = mkForce "always";
    };

    custom = {
      persist.home.directories = [
        ".config/niri/dms"
        ".local/state/DankMaterialShell"
      ];
      cache.home.directories = [
        ".cache/DankMaterialShell"
      ];
    };
  };
}
