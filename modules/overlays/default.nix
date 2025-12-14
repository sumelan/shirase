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
    # define as `pkgs.custom.foo`
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
    # use latest package
    (_final: prev: {
        protonmail-desktop = let
          linuxHash = "sha256-Xr0bcJpiQbWUIDz+zJRK96xQ/q7MUEA9LumAr9th8D4=";
          darwinHash = "";
        in
          prev.protonmail-desktop.overrideAttrs (_old: rec {
              version = "1.10.1";
              src =
                {
                  "x86_64-linux" = prev.fetchurl {
                    url = "https://proton.me/download/mail/linux/${version}/ProtonMail-desktop-beta.deb";
                    hash = linuxHash;
                  };
                  "aarch64-darwin" = prev.fetchurl {
                    url = "https://proton.me/download/mail/macos/${version}/ProtonMail-desktop.dmg";
                    hash = darwinHash;
                  };
                  "x86_64-darwin" = prev.fetchurl {
                    url = "https://proton.me/download/mail/macos/${version}/ProtonMail-desktop.dmg";
                    hash = darwinHash;
                  };
                }
    ."${prev.stdenv.hostPlatform.system}" or (throw "Unsupported system: ${prev.stdenv.hostPlatform.system}");
            });
      })
    # firefox-addons
    inputs.firefox-addons.overlays.default
  ];
}
