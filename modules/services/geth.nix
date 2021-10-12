{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.services.geth;
  configDir = config.dotfiles.configDir;
in {
  options.modules.services.geth = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    services.geth = {
      mainnet = {
        enable = true;
        http = {
          enable = true;
          apis = [ "net" "eth" ];
        };
        websocket = {
          enable = true;
          apis = [ "net" "eth" ];
        };
        metrics.enable = true;
        syncmode = "full";
      };
    };

    services.prometheus = {
      enable = true;
      configText = ''
        global:
          scrape_interval: 15s
          scrape_timeout: 10s
          evaluation_interval: 15s
        alerting:
          alertmanagers:
          - static_configs:
            - targets: []
            scheme: http
            timeout: 10s
        scrape_configs:
        - job_name: geth
          scrape_interval: 15s
          scrape_timeout: 10s
          metrics_path: /debug/metrics/prometheus
          scheme: http
          static_configs:
          - targets: ['localhost:6060']
              '';
    };
  };
}
