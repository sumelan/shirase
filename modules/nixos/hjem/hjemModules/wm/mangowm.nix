{
  inputs,
  lib,
  ...
}: let
  inherit
    (lib)
    getExe
    getExe'
    mkIf
    mkPackageOption
    mkEnableOption
    mkOption
    literalExpression
    ;
  inherit
    (lib.types)
    listOf
    str
    nullOr
    oneOf
    bool
    int
    float
    path
    attrsOf
    lines
    ;
in {
  flake.custom.hjemModules.mangowm = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.wayland.windowManager.mango;
    mangoLib = import "${inputs.mangowm}/nix/lib.nix" lib;
    variables = lib.concatStringsSep " " cfg.systemd.variables;
    extraCommands = lib.concatStringsSep " && " cfg.systemd.extraCommands;
    systemdActivation = "${getExe' pkgs.dbus "dbus-update-activation-environment"} --systemd ${variables}; ${extraCommands}";
    autostart_sh = pkgs.writeShellScript "autostart.sh" ''
      ${lib.optionalString cfg.systemd.enable systemdActivation}
      ${cfg.autostart_sh}
    '';
  in {
    options.rum = {
      wayland.windowManager.mango = {
        enable = mkEnableOption "Whether to enable mangowm, a Wayland compositor based on dwl.";

        package = mkPackageOption pkgs "mango" {};

        systemd = {
          enable = mkEnableOption ''
            Whether to enable {file}`mango-session.target` on mango startup.
            This links to {file}`graphical-session.target`.
            Some important environment variables will be imported to systemd and dbus user environment before reaching the target,
            including
                * {env}`DISPLAY`
                * {env}`WAYLAND_DISPLAY`
                * {env}`XDG_CURRENT_DESKTOP`
                * {env}`XDG_SESSION_TYPE`
                * {env}`NIXOS_OZONE_WL`
            You can extend this list using the `systemd.variables` option.
          '';

          variables = mkOption {
            type = listOf str;
            default = [
              "DISPLAY"
              "WAYLAND_DISPLAY"
              "XDG_CURRENT_DESKTOP"
              "XDG_SESSION_TYPE"
              "NIXOS_OZONE_WL"
              "XCURSOR_THEME"
              "XCURSOR_SIZE"
            ];
            example = ["--all"];
            description = ''
              Environment variables imported into the systemd and D-Bus user environment.
            '';
          };

          extraCommands = mkOption {
            type = listOf str;
            default = [
              "systemctl --user reset-failed"
              "systemctl --user start mango-session.target"
            ];
            description = ''
              Extra commands to run after D-Bus activation.
            '';
          };

          xdgAutostart = mkEnableOption ''
            autostart of applications using {manpage}`systemd-xdg-autostart-generator(8)`
          '';
        };

        settings = mkOption {
          type = let
            valueType =
              nullOr (oneOf [
                bool
                int
                float
                str
                path
                (attrsOf valueType)
                (listOf valueType)
              ])
              // {
                description = "Mango configuration value";
              };
          in
            valueType;
          default = {};
          description = ''
            Mango configuration written in Nix. Entries with the same key should be written as lists.
            Variables and colors names should be quoted.
            See <https://mangowm.github.io/docs> for more examples.

            ::: {.note}
            This option uses a structured format that is converted to Mango's configuration syntax.
            Nested attributes are flattened with underscore separators.
            For example: `animation.duration_open = 400` becomes `animation_duration_open = 400`

            Keymodes (submaps) are supported via the special `keymode` attribute.
            Each keymode is a nested attribute set under `keymode` that contains its own bindings.
            :::
          '';
          example = literalExpression ''
            {
              # Window effects
              blur = 1;
              blur_optimized = 1;
              blur_params = {
                radius = 5;
                num_passes = 2;
              };
              border_radius = 6;
              focused_opacity = 1.0;

              # Animations - use underscores for multi-part keys
              animations = 1;
              animation_type_open = "slide";
              animation_type_close = "slide";
              animation_duration_open = 400;
              animation_duration_close = 800;

              # Or use nested attrs (will be flattened with underscores)
              animation_curve = {
                open = "0.46,1.0,0.29,1";
                close = "0.08,0.92,0,1";
              };

              # Use lists for duplicate keys like bind and tagrule
              bind = [
                "SUPER,r,reload_config"
                "Alt,space,spawn,rofi -show drun"
                "Alt,Return,spawn,foot"
                "ALT,R,setkeymode,resize"  # Enter resize mode
              ];

              tagrule = [
                "id:1,layout_name:tile"
                "id:2,layout_name:scroller"
              ];

              # Keymodes (submaps) for modal keybindings
              keymode = {
                resize = {
                  bind = [
                    "NONE,Left,resizewin,-10,0"
                    "NONE,Escape,setkeymode,default"
                  ];
                };
              };
            }
          '';
        };

        extraConfig = mkOption {
          type = lines;
          default = "";
          description = ''
            Extra configuration lines to add to `~/.config/mango/config.conf`.
            This is useful for advanced configurations that don't fit the structured settings format,
            or for options that aren't yet supported by the module.
          '';
          example = ''
            # Advanced config that doesn't fit structured format
            special_option = 1
          '';
        };

        topPrefixes = mkOption {
          type = listOf str;
          default = [];
          description = ''
            List of prefixes for attributes that should appear at the top of the config file.
            Attributes starting with these prefixes will be sorted to the beginning.
          '';
          example = ["source"];
        };

        bottomPrefixes = mkOption {
          type = listOf str;
          default = [];
          description = ''
            List of prefixes for attributes that should appear at the bottom of the config file.
            Attributes starting with these prefixes will be sorted to the end.
          '';
          example = ["source"];
        };

        autostart_sh = mkOption {
          description = ''
            Shell script to run on mango startup. No shebang needed.

            When this option is set, the script will be written to
            `~/.config/mango/autostart.sh` and an `exec-once` line will be automatically added to the config to execute it.
          '';
          type = lines;
          default = "";
          example = ''
            waybar &
            dunst &
          '';
        };
      };
    };

    config = mkIf cfg.enable (
      let
        finalConfigText =
          (
            mangoLib.toMango {
              topCommandsPrefixes = cfg.topPrefixes;
              bottomCommandsPrefixes = cfg.bottomPrefixes;
            }
            cfg.settings
          )
          + lib.optionalString (cfg.extraConfig != "") cfg.extraConfig
          + lib.optionalString (cfg.autostart_sh != "") ''
            exec-once=~/.config/mango/autostart.sh
          '';

        validatedConfig = pkgs.runCommand "mango-config.conf" {} ''
          cp ${pkgs.writeText "mango-config.conf" finalConfigText} "$out"
          ${getExe cfg.package} -c "$out" -p || exit 1
        '';
      in {
        packages = [cfg.package];

        xdg.config.files = {
          "mango/config.conf" =
            mkIf (cfg.extraConfig != "" || cfg.autostart_sh != "")
            {
              source = validatedConfig;
            };
          "mango/autostart.sh" = mkIf (cfg.autostart_sh != "") {
            source = autostart_sh;
            executable = true;
          };
        };

        systemd.targets.mango-session = mkIf cfg.systemd.enable {
          description = "mango compositor session";
          documentation = ["man:systemd.special(7)"];
          bindsTo = ["graphical-session.target"];
          wants = ["graphical-session-pre.target"] ++ lib.optional cfg.systemd.xdgAutostart "xdg-desktop-autostart.target";
          after = ["graphical-session-pre.target"];
          before = lib.optional cfg.systemd.xdgAutostart "xdg-desktop-autostart.target";
        };
      }
    );
  };
}
