{
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixpkgs;
in {
  perSystem = {system, ...}: let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;

      overlays = [
        self.overlays.pkgsOverride
      ];
    };
  in {
    # initialize the pkgs for perSystem to be the nixpkgs
    _module.args = {inherit pkgs;};

    formatter = pkgs.alejandra;
  };

  flake = {
    overlays = {
      pkgsOverride = _: prev: {
        # enable the A/V Properties and see details like media length
        nautilus = prev.nautilus.overrideAttrs (o: {
          buildInputs =
            o.buildInputs
            ++ (with prev.gst_all_1; [
              gst-plugins-good
              gst-plugins-bad
            ]);
        });

        # Enabling unfree dependencies allow use of Nvidia features, the FDK AAC decoder, and a lot more.
        ffmpeg-full = prev.ffmpeg-full.override {
          withUnfree = true;
        };

        # play Blu-ray disk
        vlc = prev.vlc.override {
          libbluray-full = prev.libbluray.override {
            withAACS = true;
            withBDplus = true;
          };
        };
      };
    };

    modules.nixos.core = _: {
      nixpkgs.overlays =
        [
          self.overlays.pkgsOverride
        ]
        ++ [
          inputs.niri-nix.overlays.niri-nix
        ];
    };
  };
}
