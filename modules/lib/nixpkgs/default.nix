{lib, ...}: {
  colors = import ./colors.nix {};
  niri = import ./niri.nix {inherit lib;};
}
