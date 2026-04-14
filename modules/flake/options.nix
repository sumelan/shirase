{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) lazyAttrsOf anything;
in {
  flake = {
    # expose top level flake options
    options = {
      meta.users = mkOption {
        type = lazyAttrsOf anything;
        default = {};
        description = "User info";
      };
    };
  };
}
