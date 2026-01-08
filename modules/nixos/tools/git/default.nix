# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, options, config, pkgs, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.tools.git;
  networking = config.cogisys.system.networking;
in
  {
    options.cogisys.tools.git = with types; {
      enable = mkBoolOpt false "Enable git.";
      useOauth = mkBoolOpt false "Configure oauth credential manager.";
    };

    config = mkMerge [
      (mkIf cfg.enable {
        programs.git = {
          enable = true;
          package = pkgs.gitFull;

          config = {
            init   = { defaultBranch = "main"; };
            pull   = { rebase = true; };
            push   = { autoSetupRemote = true; };
            core   = { whitespace = "trailing-space,space-before-tab"; };
            http   = { postBuffer = 524288000; };
            advice = { detachedHead = false; };
            alias  = {
              gone = ''!git branch --format="%(refname:short) %(upstream:track)" | grep "\[gone\]"'';
              rm-gone = ''!git branch --format="%(refname:short) %(upstream:track)" | grep "\[gone\]" | cut -f1 -d " " | xargs -I{} git branch -D {}'';
            }; 
          };
        };

        environment.shellAliases.ggrep = "git grep -n";

        environment.systemPackages = [ pkgs.gh ];

      })

      (mkIf (cfg.enable && cfg.useOauth) {

        assertions = [(mkAssertionModule networking "Networking" "oauth credential manager")];

        environment.systemPackages = [ pkgs.git-credential-oauth ];

        programs.git.config.credential.helper = [
          "cache --timeout 7200" # Set the cache to 2h
          "oauth"
        ];

      })];
  }
