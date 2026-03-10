_: {
  flake.modules.nixos.syncthing-sakura = {config, ...}: {
    services.syncthing = {
      key = config.sops.secrets."syncthing/sakura-key".path;
      cert = config.sops.secrets."syncthing/sakura-cert".path;
      settings = {
        devices = {
          "minibookx" = {id = "LTAE56R-6ARZAXL-JK4KL6B-IHVTITS-AEL3TCQ-JR4ZNQQ-52QHVU2-7UU7SQI";};
          "motorola razr 50" = {id = "3BSLI47-FLXIECF-S7QZWXG-ZXTMFFV-GLVVSLS-I3MYHPS-74GIRFU-5SVA6AO";};
        };
        folders = {
          "Documents" = {
            devices = ["minibookx"];
          };
          "Music" = {
            devices = [
              "minibookx"
              "motorola razr 50"
            ];
          };
          "Pictures" = {
            devices = ["minibookx"];
          };
          "Videos" = {
            devices = ["minibookx"];
          };
          "MPD" = {
            devices = ["minibookx"];
          };
          "Youtube" = {
            devices = ["minibookx"];
          };
          "Euphonica" = {
            devices = ["minibookx"];
          };
        };
      };
    };
  };
}
