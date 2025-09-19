{
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    genAttrs
    ;
in {
  monitors = {
    "eDP-1" = {
      isMain = true;
      scale = 1.0;
      mode = {
        width = 1920;
        height = 1200;
        refresh = 60.0;
      };
      position = {
        x = 0;
        y = 0;
      };
      rotation = 0;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "sakura" = {
        hostname = "192.168.68.62";
        user = "sumelan";
        identitiesOnly = true;
        identityFile = "/home/sumelan/.ssh/id_ed25519";
        # default config
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };

  custom = let
    enableList = [
      "dms"
      "freetube"
      "protonapp"
      "rmpc"
      "spotify"
    ];

    disableList = [
    ];
  in
    {
      stylix = {
        cursor = {
          package = pkgs.capitaine-cursors-themed;
          name = "Capitaine Cursors (Nord)";
        };
        icons = {
          package = pkgs.papirus-nord.override {
            accent = "polarnight3";
          };
          dark = "Papirus-Dark";
        };
      };
    }
    // genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
