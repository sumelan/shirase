{ pkgs, ... }:
{
  # NOTE: nautilus is installed on system-wide
  environment = {
    systemPackages = with pkgs; [
      nautilus
      ffmpegthumbnailer
      p7zip-rar # support for encrypted archives
      webp-pixbuf-loader # for webp thumbnails
      xdg-terminal-exec
      libheif
      libheif.out
    ];
    pathsToLink = [ "share/thumbnailers" ];
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  niri-flake.cache.enable = true;

  # https://github.com/YaLTeR/niri/wiki/Important-Software
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      niri."org.freedesktop.impl.portal.FileChooser" = "gtk";
      niri.default = "gnome";
      common.default = "gnome";
      obs.default = "gnome";
    };
  };

  # use gnome-polkit instead
  systemd.user.services.niri-flake-polkit.enable = false;
}
