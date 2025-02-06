{ config, ... }:
let
  proj_dir = "/persist${config.home.homeDirectory}/projects";
in
{
  home = {
    shellAliases = {
      ":e" = "nvim";
      ":q" = "exit";
      ":wq" = "exit";
      c = "clear";
      cat = "bat";
      ccat = "command cat";
      crate = "cargo";
      isodate = ''date -u "+%Y-%m-%dT%H:%M:%SZ"'';
      man = "batman";
      mime = "xdg-mime query filetype";
      mkdir = "mkdir -p";
      mount = "mount --mkdir";
      np = "cd ${proj_dir}/nixpkgs";
      open = "xdg-open";
      py = "python";
      w = "watch -cn1 -x cat";
      coinfc = "pj coinfc";

      # cd aliases
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };

  # pj cannot be implemented as script as it needs to change the directory of the shell
  # bash function and completion for pj
  programs.bash.initExtra = ''
    function pj() {
      cd ${proj_dir}
      if [[ $# -eq 1 ]]; then
        cd "$1";
        fi
    }
    _pj() {
        ( cd ${proj_dir}; printf "%s\n" "$2"* )
    }
    complete -o nospace -C _pj pj
  '';

  programs.fish.functions.pj = ''
    cd ${proj_dir}
    if test (count $argv) -eq 1
      cd $argv[1]
    end
  '';

  # fish completion
  xdg.configFile."fish/completions/pj.fish".text = ''
    function _pj
      find ${proj_dir} -maxdepth 1 -type d -exec basename {} \;
    end
    complete -c pj -f -a "(_pj)"
  '';
}
