{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.niri-nix.overlays.niri-nix
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;

    useNautilus = false;
    withUWSM = false;
    withXDG = true;
  };
}
