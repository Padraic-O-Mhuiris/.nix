{
  config,
  lib,
  pkgs,
  ...
}: {
  user.packages = with pkgs; [
    git
    gitAndTools.gh
    gitAndTools.git-open
    gitAndTools.diff-so-fancy
    gitAndTools.git-crypt
  ];

  home.configFile = {
    "git/config".text = ''
      [user]
        name = ${config.user.fullName}
        email = ${config.user.email}
        signingKey = ${config.user.publicKey}
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
      [alias]
        unadd = reset HEAD
        # data analysis
        ranked-authors = !git authors | sort | uniq -c | sort -n
        emails = !git log --format="%aE" | sort -u
        email-domains = !git log --format="%aE" | awk -F'@' '{print $2}' | sort -u
      [filter "lfs"]
              required = true
              smudge = git-lfs smudge -- %f
              process = git-lfs filter-process
              clean = git-lfs clean -- %f
      [url "https://github.com/"]
           insteadOf = gh:
      [url "git@github.com:"]
           insteadOf = ssh+gh:
      [url "git@github.com:hlissner/"]
           insteadOf = gh:/
      [url "https://gitlab.com/"]
           insteadOf = gl:
      [url "https://gist.github.com/"]
           insteadOf = gist:
      [url "https://bitbucket.org/"]
           insteadOf = bb:
      [url "https://git.v0.com"]
           insteadOf = v0:
      [diff "lisp"]
            xfuncname = "^(((;;;+ )|\\(|([ \t]+\\(((cl-|el-patch-)?def(un|var|macro|method|custom)|gb/))).*)$"
      [diff "org"]
            xfuncname = "^(\\*+ +.*)$"

    '';

    ##"${configDir}/git/config";

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
