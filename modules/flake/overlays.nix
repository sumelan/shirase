{
  inputs,
  lib,
  self,
  withSystem,
  ...
}: let
  inherit (inputs) nixpkgs;
in {
  perSystem = {system, ...}: let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        self.overlays.pkgsCustom
        self.overlays.pkgsPatches
        self.overlays.writeShellApplicationCompletions
      ];
    };
  in {
    # initialize the pkgs for perSystem to be the patched nixpkgs
    _module.args = {inherit pkgs;};

    formatter = pkgs.alejandra;
  };

  flake = {
    overlays = {
      # add flake.packages as pkgs.custom
      pkgsCustom = _: prev: {
        custom = withSystem prev.stdenv.hostPlatform.system ({config, ...}: config.packages);
      };

      # misc patches to packages in pkgs
      pkgsPatches = _: prev: {
        # enable the A/V Properties and see details like media length
        nautilus = prev.nautilus.overrideAttrs (nprev: {
          buildInputs =
            nprev.buildInputs
            ++ (with prev.gst_all_1; [
              gst-plugins-good
              gst-plugins-bad
            ]);
        });
        # use my forked version
        nord-yazi = prev.yaziPlugins.nord.overrideAttrs {
          src = prev.fetchFromGitHub {
            owner = "sumelan";
            repo = "nord.yazi";
            rev = "0b97c8464ae073450e8ef10f80c89f8d07c65902";
            hash = "sha256-W8lcF40GhbdcM1PXL0SodfrOMSnpUV+Lowgzt1lRju4=";
          };
        };
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

    modules.nixos.overlays = _: {
      nixpkgs.overlays = [
        self.overlays.pkgsCustom
        self.overlays.pkgsPatches
        self.overlays.writeShellApplicationCompletions
      ];
    };
  };
}
