{lib, ...}: let
  inherit
    (lib)
    mkOption
    assertMsg
    any
    hasPrefix
    ;
  inherit (lib.types) listOf str;
  assertNoHomeDirs = paths:
    assert (assertMsg (!any (hasPrefix "/home") paths) "/home used in a root persist!"); paths;
in {
  flake.modules = {
    nixos.default = _: {
      options = {
        custom = {
          persist = {
            root = {
              directories = mkOption {
                type = listOf str;
                default = [];
                apply = assertNoHomeDirs;
                description = "Directories to persist in root filesystem";
              };
              files = mkOption {
                type = listOf str;
                default = [];
                apply = assertNoHomeDirs;
                description = "Files to persist in root filesystem";
              };
            };
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
            };
          };
          cache = {
            root = {
              directories = mkOption {
                type = listOf str;
                default = [];
                apply = assertNoHomeDirs;
                description = "Directories to persist, but not to snapshot";
              };
              files = mkOption {
                type = listOf str;
                default = [];
                apply = assertNoHomeDirs;
                description = "Files to persist, but not to snapshot";
              };
            };
            home = {
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
    };
    homeManager.default = _: {
      options.custom = {
        persist.home = {
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
        };
        cache.home = {
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
