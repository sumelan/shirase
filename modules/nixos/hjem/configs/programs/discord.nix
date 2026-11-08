{pkgs, ...}: let
  gcc = pkgs.gnome-control-center;
  niriGCC = pkgs.symlinkJoin {
    name = "gnome-control-center-niri";
    paths = [gcc];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/gnome-control-center \
        --set XDG_CURRENT_DESKTOP "gnome"
    '';
  };
in {
  hjem.users.sumelan = {
    packages = [
      pkgs.discord
      niriGCC
    ];
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".config/discord"
    ];
  };
}
