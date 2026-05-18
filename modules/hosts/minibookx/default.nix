{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos."hosts/minibookx" = _: {
    imports = builtins.attrValues {
      inherit (flake.modules.nixos) default chuwi-minibook-x;
      inherit (flake.modules.nixos) kdeconnect;
    };
    networking.hostId = "56895d2b";

    custom = {
      hardware.monitors = {
        "DSI-1" = {
          isMain = true;
          scale = 1.0;
          mode = {
            width = 1200;
            height = 1920;
            refresh = 90.000;
          };
          position = {
            x = 0;
            y = 0;
          };
          rotation = 270;
        };
      };
    };
  };
}
