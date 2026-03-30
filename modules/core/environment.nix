_: {
  flake.modules.nixos.common = {config, ...}: let
    inherit (config.hm.xdg) mimeApps;
  in {
    environment = {
      # use some shell aliases from home manager
      shellAliases =
        {
          inherit
            (config.hm.programs.bash.shellAliases)
            eza
            ls
            ll
            la
            lla
            ;
        }
        // {
          inherit
            (config.hm.home.shellAliases)
            gg # lazygit
            y # yazi
            ;
        };
    };

    xdg.mime = {
      enable = true;
      # use mimetypes defined from home-manager
      inherit (mimeApps) defaultApplications;
      addedAssociations = mimeApps.associations.added;
      removedAssociations = mimeApps.associations.removed;
    };
  };
}
