{
  inputs,
  self,
  ...
}:
inputs.nixpkgs.lib.extend (
  _: _: {
    custom = import ./. {
      inherit inputs self;
      lib = self;
    };
  }
)
