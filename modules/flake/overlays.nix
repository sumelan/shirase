{
  inputs,
  lib,
  self,
  withSystem,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (lib) makeBinPath intersectAttrs functionArgs;
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

      pkgsPatches = _: prev: {
        # use updated dgop
        dgop = prev.dgop.overrideAttrs (o: rec {
          version = "0.2.2";
          src = prev.fetchFromGitHub {
            owner = "AvengeMedia";
            repo = "dgop";
            tag = "v${version}";
            hash = "sha256-kYEFJvJApcgVgFu6QpSoNk2t0hv7AlmBARc5HPe/n+s=";
          };
          vendorHash = "sha256-OxcSnBIDwbPbsXRHDML/Yaxcc5caoKMIDVHLFXaoSsc=";
          ldflags = [
            "-w"
            "-s"
            "-X main.Version=${version}"
          ];
          nativeBuildInputs = o.nativeBuildInputs ++ [prev.makeWrapper];
          postInstall = ''
            mkdir -p $out/bin
            cp $GOPATH/bin/dgop $out/bin/dgop
            wrapProgram $out/bin/dgop --prefix PATH : "${makeBinPath [prev.pciutils]}"

            installShellCompletion --cmd dgop \
                --bash <($out/bin/dgop completion bash) \
                --fish <($out/bin/dgop completion fish) \
                --zsh <($out/bin/dgop completion zsh)
          '';
        });
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
        # use my forked version
        nord-yazi = prev.yaziPlugins.nord.overrideAttrs (o: {
          patches = (o.patches or []) ++ [./patches/nord-yazi.patch];
        });
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
              app = writeShellApplication (intersectAttrs (functionArgs writeShellApplication) shellArgs);
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

    modules.nixos.common = _: {
      nixpkgs.overlays =
        [
          self.overlays.pkgsCustom
          self.overlays.pkgsPatches
          self.overlays.writeShellApplicationCompletions
        ]
        ++ [
          inputs.niri-nix.overlays.niri-nix
        ];
    };
  };
}
