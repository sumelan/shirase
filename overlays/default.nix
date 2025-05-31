{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [
    # use niri flake
    inputs.niri.overlays.niri

    (final: prev: {
      # nautilus
      nautilus = prev.nautilus.overrideAttrs (nprev: {
        buildInputs =
          nprev.buildInputs
          ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
          ]);
      });

      # fix nix package count for nitch
      nitch = prev.nitch.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [ ./nitch-nix-pkgs-count.patch ];
      });

      # use nixfmt-rfc-style as the default
      nixfmt = prev.nixfmt-rfc-style;
    })
  ];
}
