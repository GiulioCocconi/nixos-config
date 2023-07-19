{ lib, options, config, pkgs, ... }:
with lib;

let
  cfg = config.cogisys.tools.git;
  wifi = config.cogisys.system.networking.wifi;
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
            init = { defaultBranch = "main"; };
            pull = { rebase = true; };
            push = { autoSetupRemote = true; };
            core = { whitespace = "trailing-space,space-before-tab"; };
          };
        };

        environment.shellAliases.ggrep = "git grep -n";

      })

      (mkIf (cfg.enable && cfg.useOauth) {

        assertions = [{
          assertion = wifi.enable;
          message = "In order to use oauth you need the wifi module to be enabled!";
        }];

        environment.systemPackages = with pkgs; [
          git-credential-oauth
        ];

        programs.git.config.credential.helper = [
          "cache --timeout 7200" # Set the cache to 2h
          "oauth"
        ];

      })];
    }
