_: {
  # Rotate limine interface
  boot.loader.limine.extraConfig = ''
    interface_rotation: 90
  '';

  services.iio-niri = {
    enable = true;
  };

  networking.hostId = "8425e349";

  custom = {
    wayland.windowManager.niri = {
      extraBinds = {
        "XF86MonBrightnessUp" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "call" "brightness" "increment" "5%" "backlight:intel_backlight"];
        };
        "XF86MonBrightnessDown" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "call" "brightness" "decrement" "5%" "backlight:intel_backlight"];
        };
      };
    };
  };
}
