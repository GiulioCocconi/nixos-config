{ lib, options, config, pkgs, ... }:
with lib;

let
  cfg = config.cogisys.nix;
in
  {
    options.cogisys.nix = with types; {
      enable = mkEnableOption "nix management";
    };

    config = mkIf cfg.enable {
      nix = {
        settings = {
          experimental-features = [ "nix-command" "flakes" ];
          http-connections = 50;
          warn-dirty = false;
          auto-optimise-store = true;
        };

        gc.automatic = true;
        gc.dates = "weekly";
        gc.options = "--delete-older-than 30d";
      };


      environment.systemPackages = with pkgs; [
        nixbang
        nix-melt
        vulnix
        nix-output-monitor
      ];

      system.autoUpgrade.enable = true;
    };
  }
