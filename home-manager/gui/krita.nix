{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    krita.enable = mkEnableOption "krita";
  };

  config = lib.mkIf config.custom.krita.enable {
    home.packages = [ pkgs.krita ];
  };

  custom.persist = {
    home.files = [
      ".config/kritadisplayrc"
      ".config/kritarc"
    ];
  };
}
