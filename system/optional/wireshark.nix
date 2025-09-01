{
  lib,
  config,
  pkgs,
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
    wireshark.enable =
      mkEnableOption "wireshark" // {default = config.hm.custom.wifi.enable;};
  };

  config = mkIf config.custom.wireshark.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark; # default: wireshark-cli
    };
    users.users.${user}.extraGroups = ["wireshark"];
  };
}
