{ lib, options, config, pkgs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.suites.development;
in
  {
    options.cogisys.suites.development = with types; {
      enable = mkEnableOption "development suite";
      languages = {

        cpp = {
          enable = mkBoolOpt cfg.enable "Whether to enable C/C++ support.";
          toolchain = mkOpt (enum ["GCC" "Clang"]) "Clang" "Toolchain to be used.";
        };

        llvm.enable = mkBoolOpt (cfg.languages.cpp.enable && cfg.languages.cpp.toolchain == "Clang") "Whether to install libllvm.";
        python.enable = mkBoolOpt cfg.enable "Whether to enable python3 support.";
        commonLisp = {
          enable = mkEnableOption "common lisp support";
          sbclPkgs = mkOption {
            type = listOf package;
            default = [];
            description = "Common lisp packages to install";
            example = literalExpression "[ pkgs.sbclPackages.kons-9 ]";
          };
        };
      };
    };
    config = mkMerge [
      (mkIf cfg.enable {
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
      })
      (mkIf (cfg.enable && cfg.languages.cpp.enable) {
        environment.variables.NIX_LANG_CPP = "enabled";
        environment.systemPackages = with pkgs; [cmake]
          ++ optionals (cfg.languages.cpp.toolchain == "Clang") [clang_16 lldb_16]
          ++ optionals (cfg.languages.cpp.toolchain == "GCC") [gcc_13 gdb];
      })
      (mkIf (cfg.enable && cfg.languages.llvm.enable) {
        environment.variables.NIX_LANG_LLVM = "enabled";
        environment.systemPackages = with pkgs.llvmPackages_16; [libllvm];
      })
      (mkIf (cfg.enable && cfg.languages.python.enable) {
        environment.variables.NIX_LANG_PYTHON = "enabled";
        environment.systemPackages = [pkgs.python311];
      })
      (mkIf (cfg.enable && cfg.languages.commonLisp.enable) {
        environment.variables.NIX_LANG_CLISP = "enabled";
        environment.systemPackages = [pkgs.sbcl] ++ cfg.languages.commonLisp.sbclPkgs;
      })
    ];
  }

