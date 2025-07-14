{
  pkgs,
  stdenvNoCC,
  fetchurl,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "qobuz-player";
  version = "0.3.1.2";

  src = fetchurl {
    url = "https://github.com/SofusA/qobuz-player/releases/download/v0.3.1.2/qobuz-player-x86_64-unknown-linux-gnu.tar.gz";
    hash = "sha256-NxZJpW6ySYZMexOU/EV5/YXJCTDniCTu0syKMjkeDQg=";
  };

  buildInputs = with pkgs.gst_all_1; [
    gstreamer
  ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp qobuz-player $out/bin
  '';
}
