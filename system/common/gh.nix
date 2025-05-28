_: {
  hm = {
    programs.gh = {
      enable = true;

      # https://github.com/nix-community/home-manager/issues/4744#issuecomment-1849590426
      settings = {
        version = 1;
      };
    };
    custom.persist = {
      home.directories = [ ".config/gh" ];
    };
  };
}

# TODO: setup auth token for gh if sops/agenix is enabled
