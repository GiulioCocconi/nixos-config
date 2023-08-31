{ lib, options, config, pkgs, ... }:
with lib;

let
  cfg = config.cogisys.nix;
  light = config.cogisys.light;
in
  {
    options.cogisys.nix = with types; {
      enable = mkBoolOpt false "Enable nix management.";
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

        gc.options = if light.memory
          then"-d"
          else "--delete-older-than 30d";
      };


      environment.systemPackages = with pkgs; [
        nixbang
        nix-melt
        vulnix
        nix-output-monitor
      ];
      environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
    };
  }
