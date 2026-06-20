{config, ...}: {
  perSystem = {pkgs, ...}: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    packages.niri-waytator = pkgs.writeShellApplication {
      name = "niri-waytator";
      runtimeInputs = [
        pkgs.niri
        pkgs.wl-clipboard-rs
        local.waytator
      ];
      checkPhase = "";
      text = let
        version = "1.2.4";
        src = pkgs.fetchFromGitHub {
          owner = "faetalize";
          repo = "waytator";
          tag = "v${version}";
          hash = "sha256-/Tq4fVrgss/v/+ugAueWCx1mbQlsyQ0LE4jRtIhT4qU=";
        };
      in "${src}/scripts/screenshot-to-waytator.sh";
    };
  };
}
