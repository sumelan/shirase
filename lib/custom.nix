{
  system,
  pkgs,
  inputs,
  self,
  home-manager,
  ...
}:
inputs.nixpkgs.lib.extend (
  _final: libprev:
  {
    custom = import ./. {
      inherit
        system
        pkgs
        inputs
        self
        ;
      lib = libprev;
    };
  }
  // home-manager.lib
)
