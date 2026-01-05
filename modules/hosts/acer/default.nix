{config, ...}: let
  inherit (config) flake;
in {
  flake.modules = {
    nixos.acer = _: {
      imports =
        [{networking.hostId = "22fe2870";}]
        ++ (with flake.modules.nixos; [
          default
          hardware-acer
          laptop
        ]);
    };

    homeManager.acer = _: {
      imports =
        [
          {
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
          }
        ]
        ++ (with flake.modules.homeManager; [default]);
    };
  };
}
