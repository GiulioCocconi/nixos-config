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
        ix
        difftastic
        python3
        clang_15
        lldb_15
        strace
        ltrace
        lsof
      ];

      cogisys.tools.git.useOauth = true;

    };
  }

