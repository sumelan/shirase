{inputs, ...}:
inputs.nixpkgs.lib.extend (
  _final: libprev:
    {
      custom = import ./nixpkgs {
        lib = libprev;
      };
    }
    // inputs.home-manager.lib
)
