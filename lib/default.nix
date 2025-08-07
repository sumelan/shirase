{
  system,
  pkgs,
  self,
  inputs,
  lib,
  ...
}: {
  nixos = import ./nixos.nix {
    inherit
      system
      pkgs
      self
      inputs
      lib
      ;
  };

  niri = import ./niri.nix {
    inherit lib;
  };
}
