{
  config,
  pkgs,
  ...
}: let
  inherit
    (pkgs.lib)
    mkEnableOption
    mkOption
    mkPackageOption
    mkIf
    ;
  tomlFmt = pkgs.formats.toml {};
  cfg = config.rum.programs.hylki;

  gccGnome = pkgs.symlinkJoin {
    name = "gnome-control-center";
    paths = [pkgs.gnome-control-center];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/gnome-control-center \
        --set XDG_CURRENT_DESKTOP GNOME
    '';
  };
in {
  options.rum = {
    programs.hylki = {
      enable = mkEnableOption "A GNOME-native email client built with Rust and libadwaita";
      package = mkPackageOption pkgs "hylki" {};
      settings = {
        privacy = mkOption {
          inherit (tomlFmt) type;
          default = {};
        };
        sidebar = mkOption {
          inherit (tomlFmt) type;
          default = {};
        };
        sound = mkOption {
          inherit (tomlFmt) type;
          default = {};
        };
        state = mkOption {
          inherit (tomlFmt) type;
          default = {};
        };
        window = mkOption {
          inherit (tomlFmt) type;
          default = {};
        };
      };
    };
  };

  config = mkIf cfg.enable {
    packages = [
      gccGnome
      cfg.package
    ];

    xdg.config.files = {
      "hylki/privacy.toml" = {
        generator = tomlFmt.generate "privacy.toml";
        value = cfg.settings.privacy;
      };
      "hylki/sidebar.toml" = {
        generator = tomlFmt.generate "sidebar.toml";
        value = cfg.settings.sidebar;
      };
      "hylki/sound.toml" = {
        generator = tomlFmt.generate "sound.toml";
        value = cfg.settings.sound;
      };
      "hylki/state.toml" = {
        generator = tomlFmt.generate "state.toml";
        value = cfg.settings.state;
      };
      "hylki/window.toml" = {
        generator = tomlFmt.generate "window.toml";
        value = cfg.settings.window;
      };
    };
  };
}
