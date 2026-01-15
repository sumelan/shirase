_: {
  flake.modules.nixos.syncthing-minibookx = {config, ...}: {
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
          "Videos" = {
            devices = ["sakura"];
          };
          "MPD" = {
            devices = ["sakura"];
          };
          "Euphonica" = {
            devices = ["sakura"];
          };
          "Screenshots" = {
            devices = ["sakura"];
          };
          "Wallpapers" = {
            devices = ["sakura"];
          };
        };
      };
    };
  };
}
