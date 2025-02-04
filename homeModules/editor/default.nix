{ ... }:
{
  imports = [
    ./helix
    ./neovim
  ];

  home.shellAliases = {
    nano = "nvim";
    neovim = "nvim";
    v = "nvim";
  };

  xdg = {
    mimeApps = {
      defaultApplications = {
        "text/plain" = "nvim.desktop";
        "application/x-shellscript" = "nvim.desktop";
        "application/xml" = "nvim.desktop";
      };
      associations.added = {
        "text/csv" = "nvim.desktop";
      };
    };
  };
}
