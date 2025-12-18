{
  lib,
  config,
  user,
  ...
}: let
  inherit (lib) mkForce;
  dmsConf = "${config.xdg.configHome}/niri/dms";
in {
  imports = [
    ./plugins.nix
    ./settings.nix
  ];

  programs = {
    # NOTE: edtting screenshot feature need niri-git
    dankMaterialShell = {
      enable = true;
      systemd.enable = true;
    };
  };

  systemd.user = {
    tmpfiles.rules = [
      # create dms kdl files if not existed
      "f ${dmsConf}/alttab.kdl 644 ${user} users - -"
      "f ${dmsConf}/binds.kdl 644 ${user} users - -"
      "f ${dmsConf}/colors.kdl 644 ${user} users - -"
      "f ${dmsConf}/layout.kdl 644 ${user} users - -"
      "f ${dmsConf}/outputs.kdl 644 ${user} users - -"
      "f ${dmsConf}/wpblur.kdl 644 ${user} users - -"
    ];
    # override service config flake provide
    services.dms.Service.Restart = mkForce "always";
  };

  custom.persist = {
    home = {
      directories = [
        ".config/niri/dms"
        ".local/state/DankMaterialShell"
      ];
      cache.directories = [
        ".cache/DankMaterialShell"
      ];
    };
  };
}
