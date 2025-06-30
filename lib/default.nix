{
  inputs,
  nixpkgs,
  ...
}:
inputs.nixpkgs.lib.extend (
  _: _: {
    # Your functions go here
  }
)
