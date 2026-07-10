{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos."hosts/minibookx" = {
    config,
    pkgs,
    ...
  }: {
    imports = builtins.attrValues {
      inherit (flake.modules.nixos) default chuwi-minibook-x;
      inherit (flake.modules.nixos) gui;
      inherit (flake.modules.nixos) kdeconnect;
      inherit (flake.modules.nixos) sops-nix syncthing sshConfig;
    };

    networking.hostId = "56895d2b";

    services = {
      syncthing = {
        key = config.sops.secrets."syncthing/minibookx-key".path;
        cert = config.sops.secrets."syncthing/minibookx-cert".path;
        settings = {
          devices = {
            "sakura" = {id = "DVKBE2A-EP3TVWL-VMTBIOA-PVGBRML-7JION7K-GVXA6FD-FZ7EAUV-HATEEQS";};
          };
          folders = {
            "Notes" = {
              devices = [
                "sakura"
              ];
            };
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
            refresh = 90.000;
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
