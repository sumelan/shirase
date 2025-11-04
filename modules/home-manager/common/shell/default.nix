{config, ...}: let
  proj_dir = "/persist${config.home.homeDirectory}/Projects";
in {
  imports = [
    ./bash.nix
    ./fish.nix
  ];

  home = {
    shellAliases = {
      ":e" = "nvim";
      ":q" = "exit";
      ":wq" = "exit";
      c = "clear";
      cat = "bat";
      man = "batman";

      # cd aliases
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };

  # pj cannot be implemented as script as it needs to change the directory of the shell
  # bash function and completion for pj
  programs.bash.initExtra =
    # bash
    ''
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

  programs.fish.functions.pj =
    # fish
    ''
      cd ${proj_dir}
      if test (count $argv) -eq 1
        cd $argv[1]
      end
    '';

  # fish completion
  xdg.configFile."fish/completions/pj.fish".text =
    # fish
    ''
      function _pj
        find ${proj_dir} -maxdepth 1 -type d -exec basename {} \;
      end
      complete -c pj -f -a "(_pj)"
    '';
}
