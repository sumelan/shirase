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

  custom = let
    enableList = [
    ];
    disableList = [
      "btrbk"
      "distrobox"
    ];
  in
    {
      stylix.colorTheme = "nord";
    }
    // genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
