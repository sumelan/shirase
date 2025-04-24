{ pkgs, ... }:
{
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
    # need for video/image preview
    ffmpegthumbnailer
  ];
}
