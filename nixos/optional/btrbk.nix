{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.custom = {
    btrbk.enable =
      mkEnableOption "Tool for snapshots and remote backups";
  };

  config = mkIf config.custom.btrbk.enable {
    # add extra packages on both clinet and server
    services.btrbk.extraPackages = [pkgs.lz4];
  };
}
