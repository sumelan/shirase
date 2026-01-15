{config, ...}: let
  inherit (config) flake;
in {
  flake.modules = {
    nixos."hosts/acer" = _: {
      imports =
        [{networking.hostId = "22fe2870";}]
        ++ (with flake.modules.nixos; [
          default
          hardware-acer
          laptop
        ]);
    };

    homeManager."hosts/acer" = {pkgs, ...}: {
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
            custom = {
              # hinted font: for lower or equal than 1080p
              fonts.packages = [pkgs.maple-mono.NF];
              niri.screenshot.host = "acer";
            };
          }
        ]
        ++ (with flake.modules.homeManager; [default]);
    };
  };
}
