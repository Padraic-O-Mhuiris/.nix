{ config, lib, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [ ledger hledger hledger-ui hledger-web ];
    variables = { LEDGER_FILE = "/home/padraic/.finance/finance.journal"; };
  };
}
