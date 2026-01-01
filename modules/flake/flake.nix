{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) lazyAttrsOf anything;
in {
  options.flake = {
    meta.users = mkOption {
      type = lazyAttrsOf anything;
    };
  };
}
