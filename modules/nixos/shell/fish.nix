{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.default = {
    config,
    pkgs,
    ...
  }: let
    wrapped-fish = flake.packages.${pkgs.stdenv.hostPlatform.system}.fish;
    fishAliases = flake.custom.userModules.shellAliases.fish;
  in {
    programs = {
      fish = {
        enable = true;
        package = wrapped-fish;
        # seems like shell abbreviations take precedence over aliases
        shellAbbrs =
          config.environment.shellAliases
          // fishAliases
          // {
            ehistory = ''hx "${config.hj.xdg.data.directory}/fish/fish_history"'';
          };
      };
    };

    # fish plugins
    environment = {
      # install fish completions for fish
      # https://github.com/nix-community/home-manager/pull/2408
      pathsToLink = ["/share/fish"];

      systemPackages = [
        # do not add failed commands to history
        pkgs.fishPlugins.sponge
      ];
    };

    custom.fileSystem = {
      # fish history
      cache.home.directories = [".local/share/fish"];
    };
  };
}
