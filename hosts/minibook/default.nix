{lib, ...}: let
  inherit
    (lib)
    genAttrs
    ;
in {
  hardware.chuwi-minibook-x = {
    tabletMode.enable = true;
    autoDisplayRotation = {
      enable = true;
      commands = {
        normal = ''niri msg output "DSI-1" transform normal'';
        bottomUp = ''niri msg output "DSI-1" transform 180'';
        rightUp = ''niri msg output "DSI-1" transform 270'';
        leftUp = ''niri msg output "DSI-1" transform 90'';
      };
    };
  };

  networking.hostId = "9c4c64f4";

  custom = let
    enableList = [
      "alsa"
    ];
    disableList = [
      "distrobox"
    ];
  in
    genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
