# note: this file exists just to define options for home-manager,
# impermanence is not actually used in standalone home-manager as
# it doesn't serve much utility on legacy distros
{lib, ...}: {
  options.custom = {
    persist = {
      home = {
        directories = lib.mkOption {
          type = with lib.types; listOf str;
          default = [];
          description = "Directories to persist in home directory";
        };
        files = lib.mkOption {
          type = with lib.types; listOf str;
          default = [];
          description = "Files to persist in home directory";
        };
        cache = {
          directories = lib.mkOption {
            type = with lib.types; listOf str;
            default = [];
            description = "Directories to persist, but not to snapshot";
          };
          files = lib.mkOption {
            type = with lib.types; listOf str;
            default = [];
            description = "Files to persist, but not to snapshot";
          };
        };
      };
    };
  };
}
