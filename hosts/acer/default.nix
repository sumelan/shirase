{lib, ...}: let
  inherit
    (lib)
    genAttrs
    ;
in {
  services.logind.settings.Login.HandlePowerKey = "ignore";

  custom = let
    enableList = [
    ];
    disableList = [
      "distrobox"
    ];
  in
    {
      btrbk = {
        enable = false;
        local.enable = false;
      };
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
