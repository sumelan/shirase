{
  inputs,
  self,
  home-manager,
  ...
}:
inputs.nixpkgs.lib.extend (
  _final: libprev:
  {
    custom = import ./. {
      inherit inputs self;
      lib = libprev;
    };
  }
  // home-manager.lib
)
