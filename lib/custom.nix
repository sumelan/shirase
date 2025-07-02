{
  inputs,
  self,
  nixpkgs,
  ...
}:
inputs.nixpkgs.lib.extend (
  _: _: {
    custom = import ./. {
      inherit inputs self;
      inherit (nixpkgs) lib;
    };
  }
)
