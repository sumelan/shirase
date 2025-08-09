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
      "steam"
      "mango"
    ];
    disableList = [
      "audiobookshelf"
      "distrobox"
    ];
  in
    {
      stylix.colorTheme = "catppuccin-frappe";
    }
    // lib.genAttrs enableList (_name: {
      enable = true;
    })
    // lib.genAttrs disableList (_name: {
      enable = false;
    });
}
