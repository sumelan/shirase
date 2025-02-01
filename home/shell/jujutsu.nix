_: {
  programs = {
    git.ignores = [ ".jj" ];
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "sumelan";
          email = "bathys@proton.me";
        };
        template-aliases = {
          "format_short_id(id)" = "id.shortest()";
        };
      };
    };
  };
}
