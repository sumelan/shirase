{
  inputs,
  pkgs,
  ...
}: let
  # include generated sources from nvfetcher
  dmsSources = import ./dms-plugins/generated.nix {
    inherit
      (pkgs)
      fetchFromGitHub
      fetchurl
      fetchgit
      dockerTools
      ;
  };
  yaziSources = import ./yazi-plugins/generated.nix {
    inherit
      (pkgs)
      fetchFromGitHub
      fetchurl
      fetchgit
      dockerTools
      ;
  };
in {
  nixpkgs.overlays = [
    # include packages defined as `pkgs.custom.foo`
    (_final: prev: {
      custom =
        (prev.custom or {})
        // (import ../packages {
          inherit (prev) pkgs;
          inherit inputs;
        })
        // {
          inherit (dmsSources) dms-plugins;
          inherit (yaziSources) yazi-plugins;
        };
    })
    # enable the A/V Properties and see details like media length
    (_final: prev: {
      nautilus = prev.nautilus.overrideAttrs (nprev: {
        buildInputs =
          nprev.buildInputs
          ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
          ]);
      });
    })
    # user updated euphonica package
    (_final: prev: {
      euphonica = prev.euphonica.overrideAttrs (old: rec {
        pname = "euphonica";
        version = "0.98.0-beta";
        src = prev.fetchFromGitHub {
          owner = "htkhiem";
          repo = "euphonica";
          tag = "v${version}";
          hash = "sha256-pLs8aLm2CyT8eVtbB8UQj9xSqnjViRxKjuH3A6RErjA=";
          fetchSubmodules = true;
        };
        cargoDeps = prev.rustPlatform.fetchCargoVendor {
          inherit pname version src;
          hash = "sha256-w6xZQP8QTTPKQgPCX20IvoWErrgWVisEIJKkxwtQHho=";
        };
        buildInputs = old.buildInputs ++ [prev.libsecret];
      });
    })
    # niri-flake
    inputs.niri.overlays.niri
    # firefox-addons
    inputs.firefox-addons.overlays.default
  ];
}
