{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs.unstable; [
    helix
    #################
    ###    LSP    ###
    #################
    marksman # markdown
    nil # nix
  ];

  os.user.home.configFile."helix/config.toml".text = ''
    theme = "onedark"

    [editor]
    line-number = "relative"
    mouse = false

    [editor.cursor-shape]
    insert = "bar"
    normal = "block"
    select = "underline"

    [editor.file-picker]
    hidden = false
  '';
}
