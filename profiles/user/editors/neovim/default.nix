{ config, lib, pkgs, ... }:

{
  os.user.hm = {
    programs.neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      viAlias = true;
      vimAlias = true;
      # extraConfig = ''
      #   lua << EOF
      # '' + builtins.readFile ./init.lua + "EOF";
    };
  };

  os.user.home.configFile."nvim/init.lua".source = ./init.lua;
}
