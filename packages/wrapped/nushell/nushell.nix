{
  self,
  inputs,
  pkgs,
  functions,
  extraRawConfig ? "",
  extraRuntimeInputs ? [],
}: let
  inherit
    (pkgs.lib)
    mapAttrsToList
    concatStringsSep
    getExe
    ;
  inherit (functions.print) wrappedConfig;

  nuConfig = let
    cfg = builtins.readFile ./config.nu;
    def = builtins.readFile ./def.nu;
    starship = builtins.readFile ./starship.nu;

    nix-your-shell =
      # nu
      ''
        source ${
          pkgs.runCommand "nix-your-shell-nushell-config.nu" {} ''
            ${getExe pkgs.nix-your-shell} --nom nu >> "$out"
          ''
        }
      '';

    shellAliases = {
      basic = {
        # vim-like
        ":e" = "nvim";
        ":q" = "exit";
        ":wq" = "exit";

        aa = "echo (whoami)@(hostname)";
        c = "clear";

        # cd aliases
        ".." = "cd ..";
        "..." = "cd ../..";

        # neovim
        nv = "nvim";
      };
      extra = {
        lt = "eza --tree --level=3 --icons";
        tree = "eza --tree";
        cat = "bat -p";

        # git
        gst = "git status";
        ga = "git add";
        gaa = "git add *";
        gc = "git commit";
        gcm = "git commit -m";
        gp = "git push";
        gf = "git fetch";
        grv = "git remote -v";
        lg = "lazygit";

        # help
        bat-help = "bat --plain --language=help";

        # zfs
        zls = "zfs list -o name,used,compressratio,lused,avail";
        zsls = "zfs list -t snapshot -S creation -o name,creation,used,written,refer";
      };
      nu = {
        ll = "ls -la";
        la = "ls -a";
      };
    };

    mergedAliases = shellAliases.basic // shellAliases.extra // shellAliases.nu;
    aliases = concatStringsSep "\n" (mapAttrsToList (k: v: "alias ${k} = ${v}") mergedAliases);
  in
    pkgs.writeText "nu-config" (
      cfg
      + def
      + starship
      + nix-your-shell
      + extraRawConfig
      + aliases
    );

  nuEnvConfig = let
    completions =
      # nu
      ''
        source /etc/nushell/inshellah.nu
      '';

    zoxide =
      # nu
      ''
        source ${
          pkgs.runCommand "zoxide.nu" {} ''
            ${getExe pkgs.zoxide} init nushell >> "$out"
          ''
        }
      '';

    broot =
      # nu
      ''
        source ${
          pkgs.runCommand "br.nu" {} ''
            # broot >= 1.51 exports `main` instead of `br`.
            # Rename back to `br` to keep `source` working.
            ${getExe pkgs.broot} --print-shell-function nushell | sed 's/export def --env main/export def --env br/' > $out
          ''
        }
      '';

    env = {
      STARSHIP_CONFIG = self.packages.${pkgs.stdenv.hostPlatform.system}.starship.starshipConfig;
    };

    envAttrs =
      (concatStringsSep "\n" (
        mapAttrsToList (k: v: "$env.${k} = ${builtins.toJSON v}") env
      ))
      + "\n";
  in
    pkgs.writeText "nu-env-config" (envAttrs + completions + zoxide + broot);

  runtimeEnv = let
    comview = inputs.comview.packages.${pkgs.stdenv.hostPlatform.system}.default;
    hl = inputs.hl.packages.${pkgs.stdenv.hostPlatform.system}.default;
    inshellah = inputs.inshellah.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in
    pkgs.buildEnv {
      name = "nushell-runtime-env";
      pathsToLink = ["/bin"];
      paths = with pkgs;
        [
          # Shell
          direnv
          nix-direnv
          starship
          # Command Line
          fd
          fzf
          # Git
          git
          lazygit
          # Pager
          ov
        ]
        ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
          bat
          broot
          eza
          ns
          ripgrep
          difftastic
          yt-dlp
        ])
        ++ [
          comview
          hl
          inshellah
        ]
        ++ extraRuntimeInputs;
    };

  printPkg = wrappedConfig nuConfig {
    name = "nu-print-config";
  };

  printEnvPkg = wrappedConfig nuEnvConfig {
    name = "nu-print-env";
  };
in
  pkgs.symlinkJoin {
    name = "nu";
    paths = with pkgs; [nushell];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      ln -s ${printPkg}/bin/nu-print-config $out/bin/nu-print-config
      ln -s ${printEnvPkg}/bin/nu-print-env $out/bin/nu-print-env

      check=$($out/bin/nu -c "nu-check --debug ${nuConfig}")
      if ''${check}; then
        echo "✓ config is valid"
      else
        exit 1
      fi

      wrapProgram $out/bin/nu \
        --add-flags "--config ${nuConfig}" \
        --add-flags "--env-config ${nuEnvConfig}" \
        --prefix PATH : ${runtimeEnv}/bin
    '';
    passthru.shellPath = "/bin/nu";
    meta.mainProgram = "nu";
  }
