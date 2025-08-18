{
  lib,
  inputs,
  ...
}: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-cpu-intel
  ];

  custom = let
    enableList = [
      "alsa"
    ];
    disableList = [
      "distrobox"
    ];
  in
    {
      stylix.colorTheme = "zenburn";
    }
    // lib.genAttrs enableList (_name: {
      enable = true;
    })
    // lib.genAttrs disableList (_name: {
      enable = false;
    });
}
