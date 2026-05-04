{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.common = {user, ...}: {
    imports = with flake.modules.nixos; [wifi bluetooth pipewire];

    powerManagement.enable = true;

    services = {
      upower.enable = true;
      power-profiles-daemon.enable = true; # conflict with TLP
      tlp.enable = false;
      # ssd
      fstrim.enable = true;
    };

    hardware.i2c.enable = true;
    users.users.${user}.extraGroups = ["i2c"];
  };
}
