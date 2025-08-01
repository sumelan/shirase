{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "everforest-cursors";
  version = "3212590527";

  src = fetchurl {
    url = "https://github.com/talwat/everforest-cursors/releases/download/${version}/everforest-cursors-variants.tar.bz2";
    sha256 = "sha256-xXgtN9wbjbrGLUGYymMEGug9xEs9y44mq18yZVdbiuU=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r ./everforest-cursors* $out/share/icons
    runHook postInstall
  '';

  meta = {
    description = "Everforest cursor theme, based on phinger-cursors";
    homepage = "https://github.com/talwat/everforest-cursors";
    license = lib.licenses.cc-by-sa-40;
    maintainers = with lib.maintainers; [ sumelan ];
    mainProgram = "everforest-cursors";
    platforms = lib.platforms.all;
  };
}
