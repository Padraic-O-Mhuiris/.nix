{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [ helix marksman nil ];

  os.user.home.configFile."helix/config.toml".text = ''
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
