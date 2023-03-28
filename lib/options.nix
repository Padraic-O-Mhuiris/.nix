{ lib, ... }:

with lib;
let
  dirsToAttrs = dir:
    mapAttrsRecursive (n: v: concatStringsSep "/" n)
    (filterAttrsRecursive (n: v: (isAttrs v) || hasSuffix "lua" v) (mapAttrs
      (n: v: if v == "regular" then "./${n}" else dirsToAttrs (dir + "/${n}"))
      (builtins.readDir dir)));

  readDirRecursive = path:
    mapAttrs
    (n: v: if v == "directory" then readDirRecursive (path + "/${n}") else n)
    (builtins.readDir path);

  getDirectoryPaths' = prefix: path:
    let attrs = readDirRecursive path;
    in flatten (mapAttrsToList (n: v:
      if isAttrs v then getDirectoryPaths' "${n}" v else "${prefix}/${n}")
      attrs);

  getDirectoryPaths = path: getDirectoryPaths' "" path;

  #(readDirRecursive path);

  # mapAttrs (n: v:
  #   if v == "regular" && (getFileType n) != "nix" then
  #     "./${n}"
  #   else
  #     dirsToAttrs (dir + "/${n}")) (builtins.readDir dir);
in {
  inherit getDirectoryPaths getDirectoryPaths' readDirRecursive dirsToAttrs;
  mkOpt = type: default: mkOption { inherit type default; };
}
