{
  config,
  self,
  ...
}: let
  inherit (config) flake;
  inherit (flake.custom.wrappers) mkHelix;
in {
  flake.modules.nixos.default = {
    config,
    pkgs,
    user,
    dotfile,
    ...
  }: let
    inherit (config.networking) hostName;

    pkg = pkgs.helix;

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
        inputs = ''(removeAttrs (import "${self}/.tack") ["" "__functor"])'';

        myFlake = ''(builtins.getFlake "${dotfile}")'';
      in {
        nixpkgs.expr =
          # nix
          ''import ${inputs}.nixpkgs { }'';
        options = {
          nixos.expr =
            # nix
            ''${myFlake}.nixosConfigurations.${hostName}.options'';
          flake-parts.expr =
            # nix
            ''${myFlake}.debug.options'';
        };
      };
    };
  in {
    environment = {
      systemPackages = [
        (mkHelix {inherit pkgs pkg extraCfg extraLang;})
      ];

      sessionVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
      };
    };

    hjem.users.${user} = {
      xdg.mime-apps = {
        default-applications = {
          "text/plain" = "helix.desktop";
          "application/x-shellscript" = "helix.desktop";
          "application/xml" = "helix.desktop";
        };
        added-associations = {
          "text/csv" = "helix.desktop";
        };
      };
    };

    custom.fileSystem = {
      cache.home.directories = [
        # helix log
        ".cache/helix"
      ];
    };
  };
}
