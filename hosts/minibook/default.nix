{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf genAttrs;
in {
  hardware = {
    chuwi-minibook-x = {
      tabletMode.enable = true;
      autoDisplayRotation = {
        enable = true;
        commands = {
          normal = ''niri msg output "DSI-1" transform 90'';
          rightUp = ''niri msg output "DSI-1" transform normal'';
          bottomUp = ''niri msg output "DSI-1" transform 270'';
          leftUp = ''niri msg output "DSI-1" transform 180'';
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

  services.syncthing = mkIf config.custom.syncthing.enable {
    key = config.sops.secrets."syncthing/minibook-key".path;
    cert = config.sops.secrets."syncthing/minibook-cert".path;

    settings = {
      devices = {
        "sakura" = {id = "VCKQ6LU-GNZWWFA-FGADQ44-PEWXCNN-2FT3YPC-C6XGTEY-G3APYSH-GO42PQG";};
      };
      folders = {
        "Documents" = {
          devices = ["sakura"];
        };
        "Music" = {
          devices = ["sakura"];
        };
        "Playlist" = {
          devices = ["sakura"];
        };
        "Wallpapers" = {
          devices = ["sakura"];
        };
      };
    };
  };

  custom = let
    enableList = [
      "syncthing"
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
