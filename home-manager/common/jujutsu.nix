{
  config,
  user,
  ...
}: {
  programs = {
    git.ignores = [".jj"];
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "sumelan";
          inherit (config.profiles.${user}) email;
        };
        template-aliases = {
          "format_short_id(id)" = "id.shortest()";
        };
      };
    };
  };
}
