{
  lib,
  inputs,
  ...
}: let
  inherit
    (lib)
    genAttrs
    ;
in {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-cpu-intel
  ];

  networking.hostId = "4e98920d";

  custom = let
    enableList = [
    ];
    disableList = [
      "distrobox"
    ];
  in
    {
      stylix.colorTheme = "catppuccin-frappe";
    }
    // genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
