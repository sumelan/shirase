{
  inputs,
  lib,
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
        self.overlays.pkgsPatches
        self.overlays.writeShellApplicationCompletions
      ];
    };
  in {
    # initialize the pkgs for perSystem to be the nixpkgs
    _module.args = {inherit pkgs;};

    formatter = pkgs.alejandra;
  };

  flake = {
    overlays = {
      pkgsPatches = _: prev: {
        # enable the A/V Properties and see details like media length
        nautilus = prev.nautilus.overrideAttrs (o: {
          buildInputs =
            o.buildInputs
            ++ (with prev.gst_all_1; [
              gst-plugins-good
              gst-plugins-bad
            ]);
        });
        # play Blu-ray disk
        vlc = prev.vlc.override {
          libbluray-full = prev.libbluray.override {
            withAACS = true;
            withBDplus = true;
          };
        };
      };

      # writeShellApplication with support for completions
      writeShellApplicationCompletions = _: prev: {
        custom =
          (prev.custom or {})
          // {
            writeShellApplicationCompletions = {
              name,
              completions ? {},
              ...
            } @ shellArgs: let
              inherit (prev) writeShellApplication writeText installShellFiles;
              # get the needed arguments for writeShellApplication
              app = writeShellApplication (lib.intersectAttrs (lib.functionArgs writeShellApplication) shellArgs);
              completionsStr =
                lib.concatMapAttrsStringSep " " (
                  shell: content:
                    lib.optionalString (builtins.elem shell [
                      "bash"
                      "zsh"
                      "fish"
                      "nushell"
                    ]) "--${shell} ${writeText "${shell}-completion" content}"
                )
                completions;
            in
              if completions == {}
              then app
              else
                app.overrideAttrs (o: {
                  nativeBuildInputs = (o.nativeBuildInputs or []) ++ [installShellFiles];

                  buildCommand =
                    o.buildCommand
                    + ''
                      installShellCompletion --cmd ${name} ${completionsStr}
                    '';
                });
          };
      };
    };

    modules.nixos.core = _: {
      nixpkgs.overlays =
        [
          self.overlays.pkgsPatches
          self.overlays.writeShellApplicationCompletions
        ]
        ++ [
          inputs.niri-nix.overlays.niri-nix
        ];
    };
  };
}
