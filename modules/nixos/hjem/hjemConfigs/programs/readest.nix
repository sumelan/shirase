_: {
  flake.custom.hjemConfigs.readest = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [pkgs.readest];

      xdg.mime-apps = let
        value = ["readest.desktop"];

        removed-associations = builtins.listToAttrs (map (name: {
            inherit name value;
          }) [
            "application/pdf"
            "text/plain"
            "text/markdown"
          ]);
      in {
        inherit removed-associations;
      };
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/com.bilingify.readest"
      ];

      cache.home.directories = [
        ".cache/com.bilingify.readest"
        ".local/share/com.bilingify.readest"
      ];
    };
  };
}
