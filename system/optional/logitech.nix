{
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    logitech = {
      enable = mkEnableOption "Whether to enable support for Logitech Wireless Devices";
    };
  };

  config = lib.mkIf config.custom.logitech.enable {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    hm.programs.niri.settings.spawn-at-startup =
      let
        ush = program: [
          "sh"
          "-c"
          "uwsm app -- ${program}"
        ];
      in
      [
        {
          command = ush "solaar -w hide";
        }
      ];
  };
}
