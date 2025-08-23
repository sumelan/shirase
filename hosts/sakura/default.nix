{
  lib,
  inputs,
  ...
}: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-pc-ssd
    common-cpu-amd
    common-gpu-amd
  ];

  custom = let
    enableList = [
      "alsa"
    ];
    disableList = [
      "audiobookshelf"
      "btrbk"
      "distrobox"
      "steam"
    ];
  in
    {
      stylix.colorTheme = "nord";
    }
    // lib.genAttrs enableList (_name: {
      enable = true;
    })
    // lib.genAttrs disableList (_name: {
      enable = false;
    });
}
