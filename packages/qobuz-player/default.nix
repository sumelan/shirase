{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  glib,
  gst_all_1,
}:

rustPlatform.buildRustPackage rec {
  pname = "qobuz-player";
  version = "0.3.2-3";

  src = fetchFromGitHub {
    owner = "SofusA";
    repo = "qobuz-player";
    rev = "v${version}";
    hash = "sha256-IiOuSxk6A7X/VeFwhdVKRO+2UJP6rVekMPx7Fkw1PEs=";
  };

  cargoHash = "sha256-UKjIy+vQxauW8xiz0oI7txmX106SbGO1RdnFQcLmVag=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    glib
    gst_all_1.gstreamer
  ];

  meta = {
    description = "Tui, web and rfid player for Qobuz";
    homepage = "https://github.com/SofusA/qobuz-player";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "qobuz-player";
  };
}
