{lib, ...}: let
  inherit (lib) genAttrs;
in {
  hardware = {
    chuwi-minibook-x = {
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
    i2c.enable = true;
  };

  programs.ssh = {
    extraConfig = ''
      Host sakura
        HostName 192.168.68.62
        Port 22
        User root
    '';
  };

  custom = let
    enableList = [
      "alsa"
    ];
    disableList = [
      "distrobox"
    ];
  in
    {
      btrbk = {
        enable = true;
        remote.enable = true;
      };
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
