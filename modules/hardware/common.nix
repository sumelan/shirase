_: {
  flake.modules.nixos.common = {user, ...}: {
    powerManagement.enable = true;

    services = {
      upower.enable = true;
      power-profiles-daemon.enable = true; # conflict with TLP
      tlp.enable = false;
    };

    hardware.i2c.enable = true;
    users.users.${user}.extraGroups = ["i2c"];
  };
}
