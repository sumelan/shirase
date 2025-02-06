{ config, lib, ... }:
lib.mkIf config.custom.niri.enable {
  services.hypridle = {
    enable = true;

    # NOTE: screen lock on idle is handled in lock.nix
    settings = {
      general = {
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 5 * 60;
        }
      ];
    };
  };
}
