{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "dgop";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    rev = "v${version}";
    hash = "sha256-TX8GTYg6Z9JFY+Z+0dfJHyROt94OlkuMBJJxbmxrlac=";
  };

  vendorHash = "sha256-+3o/Kg5ROSgp8IZfvU71JvbEgaiLasx5IAkjq27faLQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.buildTime=1970-01-01_00:00:00"
    "-X main.Commit=${version}"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $GOPATH/bin/cli $out/bin/dgop
  '';

  meta = {
    description = "API & CLI for System Resources";
    homepage = "https://github.com/AvengeMedia/dgop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [sumelan];
    mainProgram = "dgop";
  };
}
