{inputs, ...}:
inputs.nixpkgs.lib.extend (
  _final: libprev:
    {
      custom = import ./. {
        lib = libprev;
      };
    }
    // inputs.home-manager.lib
)
