{lib, ...}: let
  inherit (lib) mkOption;
  inherit
    (lib.types)
    listOf
    str
    bool
    ;
in {
  flake.modules.nixos.hdds = {
    options = {
      custom = {
        hdds = {
          westernDigital = mkOption {
            type = bool;
            description = "WD Elements 4TB";
            default = false;
          };
          ironWolf = mkOption {
            type = bool;
            description = "Seagate IronWolf 2TB";
            default = false;
          };
        };
      };
    };
  };
}
