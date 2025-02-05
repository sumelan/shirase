{
  lib,
  config,

}:
let
  cfg = config.custom.persist;
  hmPersistCfg = config.hm.custom.persist;
  assertNoHomeDirs =
    paths:
    assert (lib.assertMsg (!lib.any (lib.hasPrefix "/home") paths) "/home used in a root persist!");
    paths;
in
{
  options.custom = with lib; {
    persist = {
      root = {
        directories = mkOption {
          type = types.listOf types.str;
          default = [ ];
          apply = assertNoHomeDirs;
          description = "Directories to persist in root filesystem";
        };
        files = mkOption {
          type = types.listOf types.str;
          default = [ ];
          apply = assertNoHomeDirs;
          description = "Files to persist in root filesystem";
        };
        cache = {
          directories = mkOption {
            type = types.listOf types.str;
            default = [ ];
            apply = assertNoHomeDirs;
            description = "Directories to persist, but not to snapshot";
          };
          files = mkOption {
            type = types.listOf types.str;
            default = [ ];
            apply = assertNoHomeDirs;
            description = "Files to persist, but not to snapshot";
          };
        };
      };
      home = {
        directories = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Directories to persist in home directory";
        };
        files = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Files to persist in home directory";
        };
      };
    };
  };

  config = {

  }

}
