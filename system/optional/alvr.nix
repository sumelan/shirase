{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    alvr.enable = mkEnableOption "alvr";
  };

  config = lib.mkIf config.custom.alvr.enable {
    programs.alvr = {
      enable = true;
      package = pkgs.alvr;
      openFirewall = true;
    };

    custom.persist = {
      home.directories = [
        ".config/alvr"
      ];
    };
  };
}
