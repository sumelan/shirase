{lib, ...}: let
  inherit
    (lib)
    genAttrs
    ;
in {
  services.logind.settings.Login.HandlePowerKey = "ignore";

  custom = let
    enableList = [
      "alsa"
    ];
    disableList = [
      "distrobox"
    ];
  in
    genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
