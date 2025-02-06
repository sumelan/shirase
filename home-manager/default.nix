{
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./editor
    ./gui
    ./niri
    ./shell
    ./hardware.nix
    ./impermanence.nix # only contains options
    ./style.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    # do not change this value
    stateVersion = "24.05";

    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    packages =
      with pkgs;
      [
        curl
        gzip
        trash-cli
        xdg-utils
      ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    userDirs.enable = true;
    mimeApps.enable = true;
  };

  custom.persist = {
    home.directories = [
      "Desktop"
      "Documents"
      "Pictures"
    ];
  };
}
