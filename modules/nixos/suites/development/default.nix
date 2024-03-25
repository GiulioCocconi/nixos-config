{ lib, options, config, pkgs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.suites.development;
in
  {
    options.cogisys.suites.development = with types; {
      enable = mkEnableOption "development suite";
    };
    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        difftastic
        strace
        ltrace
        lsof
        gnumake
      ];

      environment.shellAliases.ix = "curl -F 'f:1=<-' ix.io";
      cogisys.tools.git.useOauth = true;
      documentation.dev.enable = true;
    };
  }

