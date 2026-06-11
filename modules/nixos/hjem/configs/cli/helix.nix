{config, ...}: let
  inherit (config) flake;
  inherit (flake.custom.wrappers) mkHelix;
in {
  flake.custom.hjemConfigs.helix = {
    config,
    pkgs,
    dotfile,
    ...
  }: let
    inherit (config.networking) hostName;
    extraCfg = {
      # use yazi as file tree picker
      # https://yazi-rs.github.io/docs/tips/#helix
      keys.normal = {
        "C-y" = [
          '':sh rm -f /tmp/unique-ca1ea106''
          '':insert-output yazi "%{buffer_name}" --chooser-file=/tmp/unique-ca1ea106''
          '':sh printf "\x1b[?1049h\x1b[?2004h" > /dev/tty''
          '':open %sh{cat /tmp/unique-ca1ea106}''
          '':redraw''
          '':set mouse false''
          '':set mouse true''
        ];
      };
    };
    extraLang = {
      language-server.nixd.config.nixd = let
        myFlake = ''(builtins.getFlake "${dotfile}")'';
      in {
        nixpkgs.expr = "import ${myFlake}.inputs.nixpkgs { }";
        options = {
          nixos.expr = "${myFlake}.nixosConfigurations.${hostName}.options";
          flake-parts.expr = "${myFlake}.debug.options";
        };
      };
    };
  in {
    hj.packages = [
      (mkHelix {inherit pkgs extraCfg extraLang;})
    ];

    custom.fileSystem = {
      cache.home.directories = [
        # helix log
        ".cache/helix"
      ];
    };
  };
}
