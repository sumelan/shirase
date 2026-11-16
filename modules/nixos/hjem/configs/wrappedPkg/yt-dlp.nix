{
  self,
  pkgs,
  ...
}: let
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) yt-dlp;
in {
  hjem.users.sumelan.packages = [
    yt-dlp
  ];
}
