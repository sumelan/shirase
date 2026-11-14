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

    shellAliases = import ./_aliases.nix {};
    mergedAliases = shellAliases.basic // shellAliases.extra // shellAliases.nu;
    aliases = concatStringsSep "\n" (mapAttrsToList (k: v: "alias ${k} = ${v}") mergedAliases);

    starship =
      # nu
      ''
        source ${
          pkgs.runCommand "starship-nushell-config.nu" {} ''
            ${getExe pkgs.starship} init nu > "$out"
          ''
        }
      '';

    nix-your-shell =
      # nu
      ''
        source ${
          pkgs.runCommand "nix-your-shell-nushell-config.nu" {} ''
            ${getExe pkgs.nix-your-shell} --nom nu >> "$out"
          ''
        }
      '';
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
          # Command Line
          fd
          fzf
          # Git
          git
          hl-log-viewer
          lazygit
          ov
        ]
        ++ (with self.packages.${stdenv.hostPlatform.system}; [
          bat
          broot
          eza
          ns
          ripgrep
          starship
          yt-dlp
        ])
        ++ [
          comview
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
