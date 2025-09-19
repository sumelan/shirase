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
    extraConfig = ''
      Host sakura
        Hostname 192.168.68.62
        Port 22
        User sumelan

        # Prevent using ssh-agent or another keyfile, useful for testing
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519
    '';
  };

  custom = let
    enableList = [
      "freetube"
      "ghostty"
      "noctalia"
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
