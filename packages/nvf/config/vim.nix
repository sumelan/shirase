# Basic Vim options common to all instances
_: {
  flake.modules.nvf.default = _: {
    vim = {
      autocmds = [
        {
          event = ["VimEnter"]; # runs once after startup
          pattern = ["*"];
          desc = "Disable [Process exited 0] virtual text";
          command = "autocmd! nvim.terminal TermClose";
          once = true;
        }
      ];

      options = {
        matchtime = 2; # briefly jump to a matching bracket for 0.2s
        exrc = true; # use project specific vimrc
        smartindent = true;
        softtabstop = 4;
        tabstop = 4;
        shiftwidth = 4;
        expandtab = true;
        shiftround = true; # round indent to multiple of 'shiftwidth' for > and < command
        wrap = true;
      };

      lineNumberMode = "relNumber";
      preventJunkFiles = true;
      searchCase = "smart";
    };
  };
}
