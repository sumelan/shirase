{
  inputs,
  lib,
  self,
  ...
}: let
  inherit (builtins) listToAttrs;
  inherit (lib) mkOption mkDefault;
in {
  flake.wrapperModules.satty = inputs.wrappers.lib.wrapModule (
    {
      config,
      wlib,
      ...
    }: let
      inherit (wlib.types) file;
      tomlFormat = config.pkgs.formats.toml {};
      sattyOptions = {
        extraSettings = mkOption {
          inherit (tomlFormat) type;
          default = {};
          example = {
            fullscreen = false;
            early-exit = true;
          };
          description = ''
            Options to add to {file}`satty.toml` file.
            See <https://github.com/Satty-org/Satty?tab=readme-ov-file#configuration-file>
            for options.
          '';
        };
      };

      baseSattyConf = {
        general = {
          # Start Satty in fullscreen mode
          fullscreen = false;
          # Exit directly after copy/save action
          early-exit = true;
          # Draw corners of rectangles round if the value is greater than 0 (0 disables rounded corners)
          corner-roundness = 12;
          # Select the tool on startup [possible values: pointer, crop, line, arrow, rectangle, text, marker, blur, brush]
          initial-tool = "brush";
          # Configure the command to be called on copy, for example `wl-copy`
          copy-command = "wl-copy";
          # Increase or decrease the size of the annotations
          annotation-size-factor = 2;
          # After copying the screenshot, save it to a file as well
          save-after-copy = true;
          # Hide toolbars by default
          default-hide-toolbars = false;
          # Experimental (since 0.20.0): whether window focus shows/hides toolbars. This does not affect initial state of toolbars, see default-hide-toolbars.
          focus-toggles-toolbars = false;
          # Fill shapes by default (since 0.20.0)
          default-fill-shapes = false;
          # The primary highlighter to use, the other is accessible by holding CTRL at the start of a highlight [possible values: block, freehand]
          primary-highlighter = "block";
          # Disable notifications
          disable-notifications = false;
          # Actions to trigger on right click (order is important)
          # [possible values: save-to-clipboard, save-to-file, exit]
          actions-on-right-click = [];
          # Actions to trigger on Enter key (order is important)
          # [possible values: save-to-clipboard, save-to-file, exit]
          actions-on-enter = ["save-to-clipboard"];
          # Actions to trigger on Escape key (order is important)
          # [possible values: save-to-clipboard, save-to-file, exit]
          actions-on-escape = ["exit"];
          # Action to perform when the Enter key is pressed [possible values: save-to-clipboard, save-to-file]
          # request no window decoration. Please note that the compositor has the final say in this. At this point. requires xdg-decoration-unstable-v1.
          no-window-decoration = true;
          # experimental feature: adjust history size for brush input smooting (0: disabled, default: 0, try e.g. 5 or 10)
          brush-smooth-history-size = 10;
          # experimental feature (NEXTRELEASE): The pan step size to use when panning with arrow keys.
          # pan-step-size = 50.0;
          # experimental feature (NEXTRELEASE): The zoom factor to use for the image.
          # 1.0 means no zooming.
          # zoom-factor = 1.1;
        };
        keybinds = {
          pointer = "p";
          crop = "c";
          brush = "b";
          line = "i";
          arrow = "z";
          rectangle = "r";
          ellipse = "e";
          text = "t";
          marker = "m";
          blur = "u";
          highlight = "g";
        };
        font = {
          family = "Montserrat";
          style = "Regular";
        };
      };
    in {
      options =
        sattyOptions
        // {
          "satty.toml" = mkOption {
            type = file config.pkgs;
            default.path = tomlFormat.generate "satty.toml" (baseSattyConf // config.extraSettings);
            visible = false;
          };
        };

      config.package = mkDefault config.pkgs.satty;
      config.flags = {
        "--config" = toString config."satty.toml".path;
      };
    }
  );

  # expose generic sattyy package without output file and color-palette
  perSystem = {pkgs, ...}: {
    packages.satty = (self.wrapperModules.satty.apply {inherit pkgs;}).wrapper;
  };

  flake.modules = {
    nixos.default = {
      config,
      pkgs,
      ...
    }: let
      tomlFormat = pkgs.formats.toml {};
      inherit (config.hm.xdg.userDirs) pictures;
      sattyOptions = {
        extraSettings = mkOption {
          inherit (tomlFormat) type;
          default = {};
          example = {
            fullscreen = false;
            early-exit = true;
          };
          description = ''
            Options to add to {file}`satty.toml` file.
            See <https://github.com/Satty-org/Satty?tab=readme-ov-file#configuration-file>
            for options.
          '';
        };
      };
    in {
      options.custom = {
        programs.satty = sattyOptions;
      };

      config = {
        nixpkgs.overlays = [
          (_: prev: {
            satty =
              (self.wrapperModules.satty.apply {
                pkgs = prev;
                extraSettings =
                  {
                    general.output-filename = "${pictures}/Satty/%Y-%m-%d_%H-%M-%S.png";
                    color-palette.palette = [
                      "#191D24"
                      "#434C5E"
                      "#ECEFF4"
                      "#5E81AC"
                      "#8FBCBB"
                      "#A3BE8C"
                      "#BF616A"
                      "#D08770"
                      "#B48EAD"
                      "#EBCB8B"
                    ];
                  }
                  // config.custom.programs.satty.extraSettings;
              }).wrapper;
          })
        ];
      };
    };

    homeManager.default = {pkgs, ...}: {
      home.packages = [
        pkgs.satty # overlayy-ed above
      ];

      xdg.mimeApps = let
        value = "satty.desktop";
        associations = listToAttrs (map (name: {
            inherit name value;
          }) [
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/png"
          ]);
      in {
        # remove `satty.desktop` from image mimetypes
        associations.removed = associations;
      };

      custom.programs.print-config = {
        satty =
          # sh
          ''moor --lang toml "${pkgs.satty.flags."--config"}"'';
      };
    };
  };
}
