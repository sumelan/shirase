_: {
  programs = {
    git.ignores = [ ".jj" ];
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "sumelan";
          email = "sumelan@proton.me";
        };
        template-aliases = {
          "format_short_id(id)" = "id.shortest()";
        };
      };
    };
  };
}
