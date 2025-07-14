{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  name = "qobuz-player";
  version = "0.3.1.2";
  src = fetchurl {
    url = "https://github.com/SofusA/qobuz-player/releases/download/v0.3.1.2/qobuz-player-x86_64-unknown-linux-gnu.tar.gz";
    sha256 = "sha512-4CyLe+3VIW7+t1OykiTTG9c5dAZYalWX0XIs4bMjzCpYe0r5WAAwNmnh/QxG1lRgVvxOqZlg3E4zpgFYkY6qgw==";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r $src $out/bin/custom-app
  '';

  meta = {
    description = "qobuz-player";
    homepage = "https://github.com/SofusA/qobuz-player";
    maintainers = [ "SofusA" ];
  };
}
