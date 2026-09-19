_: {
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Name = "Hello";
          ControllerMode = "dual";
          FastConnectable = "true";
          Enable = "Source,Sink,Media,Socket";
          Experimental = "true";
        };
        Policy = {
          AutoEnable = "true";
        };
      };
    };

    services.blueman.enable = true;

    custom.fileSystem = {
      persist.root.directories = [
        {
          directory = "/var/lib/bluetooth";
          mode = "0700";
        }
      ];
    };
  };
}
