_: {
  flake.modules.nixos.syncthing-sakura = {config, ...}: {
    services.syncthing = {
      key = config.sops.secrets."syncthing/sakura-key".path;
      cert = config.sops.secrets."syncthing/sakura-cert".path;
      settings = {
        devices = {
          "minibookx" = {id = "LTAE56R-6ARZAXL-JK4KL6B-IHVTITS-AEL3TCQ-JR4ZNQQ-52QHVU2-7UU7SQI";};
        };
        folders = {
          "Documents" = {
            devices = ["minibookx"];
          };
          "Music" = {
            devices = ["minibookx"];
          };
          "Videos" = {
            devices = ["minibookx"];
          };
          "MPD" = {
            devices = ["minibookx"];
          };
          "Euphonica" = {
            devices = ["minibookx"];
          };
          "Screenshots" = {
            devices = ["minibookx"];
          };
          "Wallpapers" = {
            devices = ["minibookx"];
          };
        };
      };
    };
  };
}
