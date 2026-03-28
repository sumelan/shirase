{
  inputs,
  lib,
  self,
  ...
}: let
  inherit (lib) getExe mkForce mkOption mkDefault;
  inherit
    (lib.types)
    attrsOf
    oneOf
    bool
    float
    int
    str
    ;
  inherit (lib.generators) toKeyValue mkKeyValueDefault;
  kittyOptions = {
    extraSettings = mkOption {
      type = attrsOf (oneOf [bool float int str]);
      default = {};
      example = {
        allow_remote_control = "yes";
        bold_font = "auto";
      };
      description = ''
        Options to add to {file}`kitty.conf` file.
        See <https://sw.kovidgoyal.net/kitty/conf/>
        for options.
      '';
    };
  };
in {
  flake.wrapperModules.kitty = inputs.wrappers.lib.wrapModule (
    {
      config,
      wlib,
      ...
    }: let
      inherit (wlib.types) file;
      toKittyConf = toKeyValue {
        mkKeyValue = mkKeyValueDefault {} " ";
      };
      baseKittyConf = {
        allow_remote_control = "yes";
        bold_font = "auto";
        bold_italic_font = "auto";
        copy_on_select = "yes";
        cursor_blink_interval = "0.5";
        cursor_shape = "block";
        cursor_stop_blinking_after = "15.0";
        cursor_trail = 3;
        cursor_trail_start_threshold = 10;
        enable_audio_bell = "no";
        font_family = "Maple Mono NF";
        font_size = 14;
        italic_font = "auto";
        placement_strategy = "top";
        scrollback_lines = "10000";
        strip_trailing_spaces = "smart";
        tab_bar_edge = "top";
        url_style = "single";
        visual_bell_duration = "0.1";
        window_padding_width = "3";
      };
    in {
      options =
        kittyOptions
        // {
          "kitty.conf" = mkOption {
            type = file config.pkgs;
            default.content = toKittyConf (baseKittyConf // config.extraSettings);
            visible = false;
          };
        };

      config.package = mkDefault config.pkgs.kitty;
      config.flags = {
        "--config" = toString config."kitty.conf".path;
      };
    }
  );

  # expose generic kitty package without color theme and SHELL
  perSystem = {pkgs, ...}: {
    packages.kitty = (self.wrapperModules.kitty.apply {inherit pkgs;}).wrapper;
  };

  flake.modules = {
    nixos.default = {
      config,
      pkgs,
      ...
    }: let
      nord = pkgs.fetchFromGitHub {
        owner = "connorholyday";
        repo = "nord-kitty";
        rev = "3a819c1f207cd2f98a6b7c7f9ebf1c60da91c9e9";
        hash = "sha256-Zbmrp2sQO0upkQ6Gtt5O4SLzPhovUDQNjvM0x8v2a0g=";
      };
      fishPath = getExe config.programs.fish.package;
    in {
      options.custom = {
        programs.kitty = kittyOptions;
      };

      config = {
        nixpkgs.overlays = [
          (_: prev: {
            kitty =
              (self.wrapperModules.kitty.apply {
                pkgs = prev;
                extraSettings =
                  {
                    # color theme
                    include = "${nord}/nord.conf";
                    # SHELL
                    env = "SHELL=${fishPath}";
                    shell = mkForce fishPath;
                  }
                  // config.custom.programs.kitty.extraSettings;
              }).wrapper;
          })
        ];
      };
    };

    homeManager.default = {pkgs, ...}: {
      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/terminal" = "kitty.desktop";
      };

      home = {
        packages = [
          pkgs.kitty # overlay-ed above
        ];
        shellAliases = {
          # change color on ssh
          ssh = "kitten ssh --kitten=color_scheme='Rosé Pine Moon'";
        };
      };

      custom.programs.print-config = {
        kitty =
          # sh
          ''moor --lang ini "${pkgs.kitty.flags."--config"}"'';
      };
    };
  };
}
