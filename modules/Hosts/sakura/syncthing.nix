_: {
  flake.modules.nixos.syncthing_sakura = {config, ...}: {
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
          "MPD" = {
            devices = ["minibookx"];
          };
          "Euphonica" = {
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
