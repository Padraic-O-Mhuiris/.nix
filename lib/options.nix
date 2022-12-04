{ lib, ... }:

with lib;

{
  mkOpt = type: default: mkOption { inherit type default; };
}
