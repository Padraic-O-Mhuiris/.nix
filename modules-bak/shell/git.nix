{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.git;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.git = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      gitAndTools.gh
      gitAndTools.git-open
      gitAndTools.diff-so-fancy
      #(mkIf config.modules.shell.gnupg.enable gitAndTools.git-crypt)
      gitAndTools.git-crypt
    ];

    home.configFile = {
      "git/config".source = "${configDir}/git/config";
      "git/ignore".text = ''
        # For emacs:
        *~
        *.*~
        #*
        .#*

        # For vim:
        *.swp
        .*.sw[a-z]
        *.un~
        .netrwhist

        # OS generated files #
        ######################
        .DS_Store?
        .DS_Store
        .CFUserTextEncoding
        .Trash
        .Xauthority
        thumbs.db
        Thumbs.db
        Icon?

        # Code stuffs #
        ###############
        .ccls-cache/
        .sass-cache/
        __pycache__/

        # Compiled thangs #
        ###################
        *.class
        *.exe
        *.o
        *.pyc
        *.elc
      '';
      "git/attributes".text = ''
*.lisp  diff=lisp
*.el    diff=lisp
*.org   diff=org
'';
  };
}
