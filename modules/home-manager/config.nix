{
  pkgs,
  user,
  ...
}: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home = {
    username = user;
    homeDirectory = "/home/" + user;
    # do not change this value
    stateVersion = "24.05";

    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    packages = builtins.attrValues {
      inherit
        (pkgs)
        curl
        gzip
        microfetch
        trash-cli
        xdg-utils
        ;
    };
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    mimeApps.enable = true;
  };

  custom.persist = {
    home.directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
    ];
  };
}
