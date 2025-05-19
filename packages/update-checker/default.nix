{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  makeWrapper,
  libnotify,
  nix,
  nvd,
  # variables
  dots ? "/home/sumelan/projects/wolborg",
  cache ? "/home/sumelan/.cache/update-checker",
}:
stdenvNoCC.mkDerivation rec {
  pname = "update-checker";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "guttermonk";
    repo = "waybar-nixos-updates";
    rev = "v${version}";
    hash = "sha256-x2PiNXt4bAVf2AMcctXUJ7XA59LO6nEPoyj7Q8Tvl4c=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = # sh
    ''
      substituteInPlace update-checker \
        --replace-fail "\$HOME/.config/nixos" "${dots}" \
        --replace-fail "\$HOME/.cache" "${cache}"
    '';

  postInstall = # sh
    ''
      install -D ./update-checker $out/bin/update-checker

      wrapProgram $out/bin/update-checker \
        --prefix PATH : ${
          lib.makeBinPath [
            libnotify
            nix
            nvd
          ]
        }
    '';

  meta = {
    description = "A Waybar update checking script for NixOS";
    homepage = "https://github.com/guttermonk/waybar-nixos-updates";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.sumelan ];
    mainProgram = "update-checker";
    platforms = lib.platforms.all;
  };
}
