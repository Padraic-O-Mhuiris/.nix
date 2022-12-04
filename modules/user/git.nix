{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [
    git
    gitAndTools.gh
    gitAndTools.git-open
    gitAndTools.diff-so-fancy
    gitAndTools.git-crypt
  ];

  os.home.configFile = {
    "git/config".text = ''
      [user]
        name = ${config.user.github}
        email = ${config.user.email}
        signingKey = ${config.user.key.gpg}
      [core]
        whitespace = trailing-space
      [init]
        defaultBranch = main
      [github]
        user = ${config.user.github}
      [rebase]
        autosquash = true
      [push]
        default = current
      [pull]
        rebase = true
      [commit]
        gpgSign = true
      [http]
        postBuffer = "524288000"
    '';

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
