{
  config,
  pkgs,
  ...
}: let
  inherit
    (pkgs.lib)
    mkIf
    getExe
    mkPackageOption
    mkEnableOption
    remove
    ;
  cfg = config.rum.programs.foot;
in {
  options.rum = {
    programs.foot = {
      enable = mkEnableOption "Fast, lightweight and minimalistic Wayland terminal emulator";
      package = mkPackageOption pkgs "foot" {};
      server = {
        enable = mkEnableOption "Foot terminal server";
      };
    };
  };

  config = mkIf cfg.enable {
    packages = [cfg.package];

    systemd.services.foot-server = mkIf cfg.server.enable {
      description = "Foot terminal server mode";
      documentation = ["man:foot(1)"];
      path = let
        pathStr = builtins.getEnv "PATH";
      in
        remove (builtins.split "[:]" pathStr);
      requires = ["%N.socket"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      environment = {
        DISPLAY = "WAYLAND_DISPLAY";
      };
      wantedBy = ["graphical-session.target"];

      serviceConfig = {
        ExecStart = "${getExe cfg.package} --server=3";
        Restart = "on-failure";
        OOMPolicy = "continue";
      };
    };
  };
}
