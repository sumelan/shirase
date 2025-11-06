# NOTE: this file exists just to define options for home-manager,
{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) listOf str;
in {
  options.custom = {
    persist = {
      home = {
        directories = mkOption {
          type = listOf str;
          default = [];
          description = "Directories to persist in home directory";
        };
        files = mkOption {
          type = listOf str;
          default = [];
          description = "Files to persist in home directory";
        };
        cache = {
          directories = mkOption {
            type = listOf str;
            default = [];
            description = "Directories to persist, but not to snapshot";
          };
          files = mkOption {
            type = listOf str;
            default = [];
            description = "Files to persist, but not to snapshot";
          };
        };
      };
    };
  };
}
