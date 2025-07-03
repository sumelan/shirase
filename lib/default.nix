{
  self,
  inputs,
  lib,
  ...
}:
{
  nixos = import ./nixos.nix {
    inherit self inputs lib;
  };

  niri = import ./niri.nix {
    inherit lib;
  };

  utils = import ./utils.nix {
    inherit lib;
  };
}
