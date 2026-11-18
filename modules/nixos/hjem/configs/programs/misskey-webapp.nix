{pkgs, ...}: {
  hjem.users.sumelan.rum = {
    programs.webapp = {
      enable = true;
      app = {
        name = "Misskey.io";
        url = "https://misskey.io";
        icon = pkgs.fetchurl {
          url = "https://media.misskeyusercontent.jp/io/2f626cae-dc9b-435d-8ec3-7e3e8a25005b.png";
          hash = "sha256-0qtRSkNRNsbc7EbXn2DqYxZ18lbp7rhSejXln6t5sHM=";
        };
      };
    };
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".local/share/Misskey.io-webapp"
    ];
  };
}
