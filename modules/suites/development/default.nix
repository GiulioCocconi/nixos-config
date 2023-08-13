{ lib, options, config, pkgs, ...}:
with lib;

let
  cfg = config.cogisys.suites.development;
in
  {
    options.cogisys.suites.development = with types; {
      enable = mkBoolOpt false "Enable development suite.";
    };
    config = mkIf cfg.enable {

      environment.systemPackages = with pkgs; [
        python3
        clang
        strace
        ltrace
        lsof
      ];

      cogisys.tools.git.useOauth = true;

    };
  }

