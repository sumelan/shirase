_: {
  # Rotate limine interface
  boot.loader.limine.extraConfig = ''
    interface_rotation: 90
  '';

  services.iio-niri = {
    enable = true;
    extraArgs = ["--monitor" "DSI-1" "--transform" "90" "180" "270" "normal"];
  };

  networking.hostId = "8425e349";

  custom = {
    wayland.windowManager.niri = {
      extraBinds = let
        hotkey = color: name: text: ''<span foreground='${color}'>[${name}]</span> ${text}'';
      in {
        "XF86MonBrightnessUp" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "call" "brightness" "increment" "5%" "backlight:intel_backlight"];
        };
        "XF86MonBrightnessDown" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "call" "brightness" "decrement" "5%" "backlight:intel_backlight"];
        };
        "Mod+Escape" = {
          _props = {
            hotkey-overlay-title = hotkey "#ef9f76" "󰗢  niri" "Toggle Touchpad";
            allow-when-locked = true;
            repeat = false;
          };
          spawn = ["niri" "msg" "action" "toggle-touchpad"];
        };
      };
    };
  };
}
