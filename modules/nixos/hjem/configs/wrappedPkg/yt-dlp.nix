{
  self,
  pkgs,
  ...
}: {
  hjem.users.sumelan.packages = [
    self.packages.${pkgs.stdenv.hostPlatform.system}.yt-dlp
  ];
}
