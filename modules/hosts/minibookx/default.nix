{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos."hosts/minibookx" = {
    config,
    pkgs,
    ...
  }: {
    imports = with flake.modules.nixos;
      [chuwi-minibook-x]
      ++ [default mpd gui]
      ++ [sops-nix syncthing]
      ++ [ebook euphonica kdeconnect];

    networking.hostId = "56895d2b";

    programs.ssh = {
      extraConfig = ''
        Host sakura
          HostName 192.168.68.62
          Port 22
          User root
      '';
    };

    services.syncthing = {
      key = config.sops.secrets."syncthing/minibookx-key".path;
      cert = config.sops.secrets."syncthing/minibookx-cert".path;
      settings = {
        devices = {
          "sakura" = {id = "DVKBE2A-EP3TVWL-VMTBIOA-PVGBRML-7JION7K-GVXA6FD-FZ7EAUV-HATEEQS";};
        };
        folders = {
          "Documents" = {
            devices = ["sakura"];
          };
          "Music" = {
            devices = ["sakura"];
          };
          "Pictures" = {
            devices = ["sakura"];
          };
          "Videos" = {
            devices = ["sakura"];
          };
          "MPD" = {
            devices = ["sakura"];
          };
          "Youtube" = {
            devices = ["sakura"];
          };
          "Euphonica" = {
            devices = ["sakura"];
          };
        };
      };
    };

    custom = {
      hardware.monitors = {
        "DSI-1" = {
          isMain = true;
          scale = 1.0;
          mode = {
            width = 1200;
            height = 1920;
            refresh = 50.002;
          };
          position = {
            x = 0;
            y = 0;
          };
          rotation = 270;
        };
      };

      # hinted font: for lower or equal than 1080p
      fonts.packages = [pkgs.maple-mono.NF];
    };
  };
}
