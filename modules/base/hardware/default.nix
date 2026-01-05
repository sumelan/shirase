_: {
  flake.modules.nixos = {
    default = {user, ...}: {
      powerManagement.enable = true;
      services = {
        upower.enable = true;
        power-profiles-daemon.enable = true; # conflict with TLP
        tlp.enable = false;
      };
      hardware.i2c.enable = true;
      users.users.${user}.extraGroups = ["i2c"];
    };

    laptop = {
      pkgs,
      user,
      ...
    }: {
      # disbale USB after sometime of inactivity
      powerManagement.powertop.enable = true;
      services = {
        libinput.enable = true;
        keyd = {
          enable = true;
          keyboards = {
            default = {
              ids = ["*"];
              settings = {
                main = {
                  #  shift = "oneshot(shift)"; # you can now simply tap shift instead of having to hold it.
                  #  meta = "oneshot(meta)";
                  #  control = "oneshot(control)";
                  leftalt = "alt";
                  rightalt = "altgr";
                  capslock = "`";
                  menu = "shift";
                };
              };
            };
          };
        };
      };
      # wireshark
      programs.wireshark = {
        enable = true;
        package = pkgs.wireshark; # default value: wireshark-cli
      };
      users.users.${user}.extraGroups = ["wireshark"];
      custom.persist.root.directories = [
        "/etc/NetworkManager"
      ];
    };

    logitech = _: {
      hardware.logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };
    };

    opentabletdriver = _: {
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
      custom.persist.home.directories = [
        ".config/OpenTabletDriver"
      ];
    };

    qmk = _: {
      hardware.keyboard.qmk = {
        enable = true;
        keychronSupport = true;
      };
    };
  };
}
