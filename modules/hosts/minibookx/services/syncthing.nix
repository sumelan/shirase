_: {
  flake.modules.nixos."hosts/minibookx" = {config, ...}: {
    services.syncthing = {
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
}
