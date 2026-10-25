{pkgs, ...}: {
  hjem.users.sumelan = {
    packages = [
      pkgs.picard
      pkgs.asunder
    ];
  };
}
