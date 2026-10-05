{inputs, ...}: let
  inherit (inputs) nixpkgs;
in {
  perSystem = {system, ...}: let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [];
    };
  in {
    # initialize the pkgs for perSystem to be the nixpkgs
    _module.args = {inherit pkgs;};
    formatter = pkgs.alejandra;
  };
}
