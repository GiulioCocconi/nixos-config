{ lib, options, config, pkgs, ...}:
with lib;
with lib.cogisys;

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
        python311
        clang_15
        lldb_15
        llvmPackages_15.libllvm
        strace
        ltrace
        lsof
      ];

      cogisys.tools.git.useOauth = true;

    };
  }

