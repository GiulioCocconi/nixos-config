# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, options, config, pkgs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.tools.zsh;
  nix = config.cogisys.nix;
in
  {
    options.cogisys.tools.zsh = with types; {
      enable = mkBoolOpt false "Enable zsh.";
    };

    config = mkMerge [
      (mkIf cfg.enable {
        programs.zsh = {
          enable = true;

          syntaxHighlighting.enable = true;
          autosuggestions.enable = true;


          interactiveShellInit = "zstyle ':completion:*' menu select";

        };




        # TODO: Add autopairs plugin

        users.defaultUserShell = pkgs.zsh;

      })
      (mkIf (nix.enable && cfg.enable) {
        environment.shellAliases.nix-shell = "nix-shell --command zsh";
      })
    ];
  }
