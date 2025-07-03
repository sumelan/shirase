{
  inputs,
  self,
  home-manager-stable,
  home-manager-unstable,
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
  // home-manager-stable.lib
  // home-manager-unstable.lib
)
