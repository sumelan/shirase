{
  lib,
  config,
  pkgs,
  user,
  ...
}:
{
  options.custom = {
    wireshark.enable = lib.mkEnableOption "wireshark" // {
      default = config.hm.custom.wifi.enable;
    };
  };

  config = lib.mkIf config.custom.wireshark.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark; # default: wireshark-cli
    };
    users.users.${user}.extraGroups = [ "wireshark" ];
  };
}
