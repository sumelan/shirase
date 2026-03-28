{config, ...}:
config.pkgs.writeTextFile {
  name = "zathurarc";
  destination = "/zathurarc"; # zathura expects a directory
  text = ''
    set adjust-open	"best-fit"
    set page-padding	"1"
    set recolor	"true"
    set statusbar-h-padding	"0"
    set statusbar-v-padding	"0"
    map D   toggle_page_mode
    map J   zoom out
    map K   zoom in
    map R   rotate
    map d   scroll half-down
    map i   recolor
    map p   print
    map r   reload
    map u   scroll half-up

    ${config.extraSettings}
  '';
}
