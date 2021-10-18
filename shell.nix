{ mkShell, sops-import-keys-hook, python3 }:

mkShell {
  sopsPGPKeyDirs = [ "./keys/hosts" ];
  sopsCreateGPGHome = true;
  nativeBuildInputs = [ sops-import-keys-hook python3.pkgs.invoke ];
}
