{ stdenvNoCC, fetchFromGithub, ... }:
stdenvNoCC.mkDerivation {
  pname = "hyperfluent-grub-theme";
  version = "1.0.1";
  src = pkgs.fetchFromGitHub {
    owner = "Coopydood";
    repo = "HyperFluent-GRUB-Theme";
    rev = "v1.0.1";
    hash = "sha256-Als4Tp6VwzwHjUyC62mYyiej1pZL9Tzj4uhTRoL+U9Q=";
  };
  installPhase = "cp -r $src/nixos $out";
}
