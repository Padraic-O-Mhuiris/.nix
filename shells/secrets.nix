{ pkgs, ... }:
pkgs.devshell.mkShell {
  name = "secrets";
  packages = with pkgs; [ sops age ];
  env = [
    {
      name = "SOPS_AGE_KEY";
      eval = "$(pass show nixos/sops/padraic.age)";
    }
    {
      name = "SOPS_AGE_PUBLIC_KEY";
      eval = "$(age-keygen -y <<< $(pass show nixos/sops/padraic.age))";
    }
    {
      name = "EDITOR";
      value = "vim";
    }
  ];
}
