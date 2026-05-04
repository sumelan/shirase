_: {
  flake.modules.nixos.opentabletdriver = _: {
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
