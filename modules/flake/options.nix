# Declares a top-level option that is used in other modules.
{lib, ...}: let
  inherit
    (lib)
    mkOption
    filter
    hasInfix
    ;
  inherit
    (lib.types)
    lazyAttrsOf
    anything
    bool
    ;
in {
  options = {
    flake = {
      # profile
      meta = mkOption {
        type = lazyAttrsOf anything;
      };
      # silence warning about setting multiple user password options
      # https://github.com/NixOS/nixpkgs/pull/287506#issuecomment-1950958990
      warnings = mkOption {
        apply = filter (
          w: !(hasInfix "If multiple of these password options are set at the same time" w)
        );
      };
      # impermanence
      persist = mkOption {
        type = lazyAttrsOf anything;
      };
      cache = mkOption {
        type = lazyAttrsOf anything;
      };
    };

    hm.flake = {
      monitors = mkOption {
        type = lazyAttrsOf anything;
      };
      xwayland = mkOption {
        type = bool;
      };
      persist = mkOption {
        type = lazyAttrsOf anything;
      };
      cache = mkOption {
        type = lazyAttrsOf anything;
      };
    };
  };
}
