{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    qmk.enable = mkEnableOption "QMK";
  };

  config = lib.mkIf config.custom.qmk.enable {
    hardware.keyboard.qmk.enable = true;

    # required for vial to work
    environment.systemPackages = with pkgs; [
      vial
      via
    ];

    # Keychron K11 Max
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="3434", ATTR{idProduct}=="0AB9", GROUP="plugdev", TAG+="uaccess"
    '';
  };
}
