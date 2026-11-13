{pkgs, ...}: {
  users.users = {
    syncoid = {
      isNormalUser = false; # keep it a service account...
      group = "syncoid";
      shell = pkgs.bashInteractive; # ...but with a real shell
    };
  };
}
