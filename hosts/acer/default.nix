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
        enable = true;
        local.enable = true;
      };
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
