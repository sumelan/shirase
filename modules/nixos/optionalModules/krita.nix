_: {
  flake.modules.nixos.krita = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [pkgs.krita];

      xdg.mime-apps = {
        removed-associations = {
          "image/jpeg" = "krita_jpeg.desktop";
          "image/gif" = "krita_gif.desktop";
          "image/webp" = "krita_webp.desktop";
          "image/png" = "krita_png.desktop";
          "application/pdf" = "krita_pdf.desktop";
        };
      };
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".local/share/krita"
      ];
    };
  };
}
