_: {
  flake.modules.nixos."hosts/minibookx" = {config, ...}: {
    security.nix-secrets.secrets = let
      permissions = {
        mode = "0660";
        owner = config.services.syncthing.user;
        inherit (config.services.syncthing) group;
      };
    in {
      "syncthing/minibookx-key" = permissions;
      "syncthing/minibookx-cert" = permissions;
    };

    services.syncthing = {
      key = config.security.nix-secrets.secrets."syncthing/minibookx-key".path;
      cert = config.security.nix-secrets.secrets."syncthing/minibookx-cert".path;
      settings = {
        devices = {
          "sakura" = {id = "DVKBE2A-EP3TVWL-VMTBIOA-PVGBRML-7JION7K-GVXA6FD-FZ7EAUV-HATEEQS";};
          "motorola razr 50" = {id = "3BSLI47-FLXIECF-S7QZWXG-ZXTMFFV-GLVVSLS-I3MYHPS-74GIRFU-5SVA6AO";};
        };
        folders = {
          "Notes" = {
            devices = [
              "sakura"
              "motorola razr 50"
            ];
          };
        };
      };
    };
  };
}
