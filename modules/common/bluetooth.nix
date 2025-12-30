_: {
  flake = {
    modules = {
      nixos.default = {
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
      };

      homeManager.default = {
        services = {
          # mpris user service to control media player over bluetooth
          mpris-proxy.enable = true;
          blueman-applet.enable = true;
        };
      };
    };
    persist.root.directories = ["/var/lib/bluetooth"];
  };
}
