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
    package = pkgs.niri;

    useNautilus = true;
    withUWSM = false;
    withXDG = true;
  };
}
