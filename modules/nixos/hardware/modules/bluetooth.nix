_: {
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      # need for bluetooth trackpad to work
      input = {
        General = {
          UserspaceHID = true;
        };
      };
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
      persist.root.directories = ["/var/lib/bluetooth"];
    };
  };
}
