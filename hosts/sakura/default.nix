{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    genAttrs
    mkIf
    ;
in {
  services.btrbk.sshAccess = mkIf config.custom.hdds.enable [
    {
      key = "";
      roles = [
        "target"
        "info"
        "receive"
        "delete"
      ];
    }
  ];

  custom = let
    enableList = [
      "alsa"
      "hdds"
    ];
    disableList = [
      "audiobookshelf"
      "distrobox"
      "steam"
    ];
  in
    genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
