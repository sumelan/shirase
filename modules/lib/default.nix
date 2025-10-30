{inputs, ...}:
inputs.nixpkgs.lib.extend (
  _final: libprev:
    {
      custom = import ./custom.nix {
        lib = libprev;
      };
    }
    // inputs.home-manager.lib
)
