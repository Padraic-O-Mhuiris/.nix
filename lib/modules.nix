{ self, lib, ... }:

let
  inherit (builtins) attrValues readDir pathExists concatLists readFile;
  inherit (lib)
    id mapAttrsToList mapAttrs filterAttrs hasPrefix hasSuffix nameValuePair
    removeSuffix;
  inherit (self.attrs) mapFilterAttrs;
in rec {
  mapModules = dir: fn:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n)) (n: v:
      let path = "${toString dir}/${n}";
      in if v == "directory" && pathExists "${path}/default.nix" then
        nameValuePair n (fn path)
      else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n then
        nameValuePair (removeSuffix ".nix" n) (fn path)
      else
        nameValuePair "" null) (readDir dir);

  mapModules' = dir: fn: attrValues (mapModules dir fn);

  mapModulesRec = dir: fn:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n)) (n: v:
      let path = "${toString dir}/${n}";
      in if v == "directory" then
        nameValuePair n (mapModulesRec path fn)
      else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n then
        nameValuePair (removeSuffix ".nix" n) (fn path)
      else
        nameValuePair "" null) (readDir dir);

  mapModulesRec' = dir: fn:
    let
      dirs = mapAttrsToList (k: _: "${dir}/${k}")
        (filterAttrs (n: v: v == "directory" && !(hasPrefix "_" n))
          (readDir dir));
      files = attrValues (mapModules dir id);
      paths = files ++ concatLists (map (d: mapModulesRec' d id) dirs);
    in map fn paths;

  _getHostKeys = dir: fn:
    let
      dirs = (filterAttrs
        (n: v: v == "directory" && pathExists (dir + "/${n}/key.pub"))
        (builtins.readDir dir));
    in (fn: (n: v: removeSuffix "\n" (readFile (dir + "/${n}/key.pub"))) dirs);

  hostKeysAttrs = dir: _getHostKeys dir mapAttrsToList;
  hostKeysList = dir: _getHostKeys dir mapAttrs;

}
