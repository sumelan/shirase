_: {
  flake.modules.nixos.pen-tablet = _: {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/OpenTabletDriver"
      ];
    };
  };
}
